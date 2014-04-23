Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaDWRGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:06:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaDWRGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:06:11 -0400
Message-ID: <1398272768.23603.1.camel@linux-fkkt.site>
Subject: Re: [PATCH v2 01/24] input: Add ff-memless-next module
From: Oliver Neukum <oneukum@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi,
        simon@mungewell.org
Date: Wed, 23 Apr 2014 19:06:08 +0200
In-Reply-To: <20140423155923.GB10531@core.coreip.homeip.net>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net>
	 <1398175209-9565-2-git-send-email-madcatxster@devoid-pointer.net>
	 <1398255179.32091.1.camel@linux-fkkt.site>
	 <20140423155923.GB10531@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 08:59 -0700, Dmitry Torokhov wrote:
> On Wed, Apr 23, 2014 at 02:12:59PM +0200, Oliver Neukum wrote:
> > On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> > > +/* Some devices might have a limit on how many uncombinable effects
> > > + * can be played at once */
> > > +static int mlnx_upload_conditional(struct mlnx_device *mlnxdev,
> > > +                                  const struct ff_effect *effect)
> > > +{
> > > +       struct mlnx_effect_command ecmd = {
> > > +               .cmd = MLNX_UPLOAD_UNCOMB,
> > > +               .u.uncomb.id = effect->id,
> > > +               .u.uncomb.effect = effect
> > > +       };
> > > +       return mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private,
> > > &ecmd);
> > > +}
> > > +
> > 
> > This mean you are building the structure on the stack
> > 
> > 1. Are you sure nobody retains a reference?
> > 2. That is needlessly inefficient
> 
> Why is it inefficient?

The compiler has to include the data structure and then make
a memcopy to the stack. Instead a pointer to the predined structure
could be passed.

	Regards
		Oliver


