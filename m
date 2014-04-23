Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaDWMas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:30:48 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49609 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaDWMap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:30:45 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v2 01/24] input: Add ff-memless-next module
Date: Wed, 23 Apr 2014 14:30:39 +0200
Message-ID: <12060887.UbTEf5RVBB@sigyn>
User-Agent: KMail/4.13 (Linux/3.14.1-1-my-rd; KDE/4.13.0; x86_64; ; )
In-Reply-To: <1398255179.32091.1.camel@linux-fkkt.site>
References: <1398175209-9565-1-git-send-email-madcatxster@devoid-pointer.net> <1398175209-9565-2-git-send-email-madcatxster@devoid-pointer.net> <1398255179.32091.1.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 of April 2014 14:12:59 Oliver Neukum wrote:
> On Tue, 2014-04-22 at 15:59 +0200, Michal Malý wrote:
> > +/* Some devices might have a limit on how many uncombinable effects
> > + * can be played at once */
> > +static int mlnx_upload_conditional(struct mlnx_device *mlnxdev,
> > +                                  const struct ff_effect *effect)
> > +{
> > +       struct mlnx_effect_command ecmd = {
> > +               .cmd = MLNX_UPLOAD_UNCOMB,
> > +               .u.uncomb.id = effect->id,
> > +               .u.uncomb.effect = effect
> > +       };
> > +       return mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private,
> > &ecmd);
> > +}
> > +
> 
> This mean you are building the structure on the stack
> 
> 1. Are you sure nobody retains a reference?
Yes. The command is a one-shot thing so it makes no sense to hold a persistent 
reference to it. Should the HW-specific driver need to keep any data from the 
command - if the uses a workqueue to submit data to the device for instance - 
it should keep its own copy of the data. The idea is to keep MLNX and HW-
specific driver as separated as possible to prevent any race conditions.

> 2. That is needlessly inefficient
Are you suggesting I drop the 'consts' and keep the memory preallocated?

Thanks for the feedback,
Michal

