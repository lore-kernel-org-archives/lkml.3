Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaD0K57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:57:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60916 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaD0K55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:57:57 -0400
Date: Sun, 27 Apr 2014 12:57:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 07/14] HSI: Add common DT binding for HSI client
 devices
Message-ID: <20140427105755.GA12265@amd.pavel.ucw.cz>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-8-git-send-email-sre@kernel.org>
 <20140419191612.GG5148@amd.pavel.ucw.cz>
 <20140425182535.GB22721@earth.universe>
 <20140425205926.GA30032@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425205926.GA30032@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-04-25 22:59:27, Sebastian Reichel wrote:
> On Fri, Apr 25, 2014 at 08:25:36PM +0200, Sebastian Reichel wrote:
> > On Sat, Apr 19, 2014 at 09:16:12PM +0200, Pavel Machek wrote:
> > > On Sat 2014-03-29 01:31:43, Sebastian Reichel wrote:
> > > > Implement and document generic DT bindings for HSI clients.
> > > > 
> > > > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > > 
> > > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > > diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
> > > > index 07e1639..5973906 100644
> > > > --- a/drivers/hsi/hsi.c
> > > > +++ b/drivers/hsi/hsi.c
> > > > @@ -26,8 +26,14 @@
> > > >  #include <linux/slab.h>
> > > >  #include <linux/string.h>
> > > >  #include <linux/notifier.h>
> > > > +#include <linux/of.h>
> > > > +#include <linux/of_device.h>
> > > >  #include "hsi_core.h"
> > > 
> > > 
> > > > +	err = hsi_of_property_parse_mode(client, "hsi-mode", &mode);
> > > > +	if (err) {
> > > > +		err = hsi_of_property_parse_mode(client, "hsi-rx-mode",
> > > > +						 &cl->rx_cfg.mode);
> > > > +		if (err)
> > > > +			goto err;
> > > > +
> > > > +		err = hsi_of_property_parse_mode(client, "hsi-tx-mode",
> > > > +						 &cl->tx_cfg.mode);
> > > > +		if (err)
> > > > +			goto err;
> > > 
> > > Will this need some #ifdef CONFIG_OF?
> > 
> > It would only be needed to reduce the amount of kernel code for
> > disabled Device Tree. I don't think its worth it, since there is no
> > platform in the mainline kernel, which uses HSI without DT.
> 
> mh actually it is needed, since there is no stub provided for
> of_modalias_node in non DT mode (there are stubs for all other
> of_* methods used). I will include the ifdef in PATCHv5.

Alternatively, you can make driver depend on DT...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
