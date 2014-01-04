Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaADWbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:31:40 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39465 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaADWbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:31:38 -0500
Date: Sat, 4 Jan 2014 14:31:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v3 1/2] regulator: anatop-regulator: Fix the error
 handling on probe
Message-ID: <20140104223135.GA18213@core.coreip.homeip.net>
References: <1387809881-16092-1-git-send-email-festevam@gmail.com>
 <20131224130357.GD30815@sirena.org.uk>
 <20140104000213.GA23926@core.coreip.homeip.net>
 <CAOMZO5Bg1fMGBbYYkVTNh-ENPovkZ9t-sD92e4fGV+_oKTG9cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Bg1fMGBbYYkVTNh-ENPovkZ9t-sD92e4fGV+_oKTG9cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 02:00:52PM -0200, Fabio Estevam wrote:
> Hi Dmitry,
> 
> On Fri, Jan 3, 2014 at 10:02 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tue, Dec 24, 2013 at 01:03:57PM +0000, Mark Brown wrote:
> >> On Mon, Dec 23, 2013 at 12:44:40PM -0200, Fabio Estevam wrote:
> >> > From: Fabio Estevam <fabio.estevam@freescale.com>
> >> >
> >> > Currently when of_get_parent() or syscon_node_to_regmap() fail
> >> > 'kfree(sreg->name)' is not called, which is incorrect.
> >>
> >> Applied both, thanks.
> >
> > Sorry for being too later, but why are we making copy to begin with? It
> > is not like DT data will disappear later on.
> 
> Which lines of code are you referring to, please?

I am talking about this:

	sreg->name = kstrdup(of_get_property(np, "regulator-name", NULL),
			     GFP_KERNEL);

Whatis the reason for kstrdup? Can we simply say:

	sreg->name = of_get_property(np, "regulator-name", NULL);

Thanks.

-- 
Dmitry
