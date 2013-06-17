Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3FQLKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:10:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54364 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab3FQLKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:10:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18s/ytlC82RnSMv5skp/AYe
Date: Mon, 17 Jun 2013 04:10:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130617111031.GQ20992@atomide.com>
References: <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130614 14:34]:
> > * Pavel Machek <pavel@ucw.cz> [130613 16:14]:
> > 
> > No, there really are two instances of mux registers even on omap3,
> > but I missed that earlier while reading the docs, and with the legacy
> > mux framework it does not matter which mux domain it is. But it
> > matters for pinctrl-single as it ioremaps the ranges separately.
> 
> Yes, you are right, with debugging prints it was easy to fix.

OK cool.
 
> > This is not a good way of doing muxing, hogging all the pins under
> > omap3_pmx_core will make it impossible to unload pinctrl-single
> > as a module, which is not nice for distros and developers.
> 
> Does omap4 do it correctly? I don't see how that works :-(.

Just group the pins for each device using them. You can do:

$ grep hsmmc1 /sys/kernel/debug/omap_mux/board/core

And then you get the mmc1 pin settings that you can place under
&mmc1 entry in your board specific .dts file.
 
> Anyway... here's my current version, and thanks for all the help. I
> guess I'll need to figure out clocks next, because I'd really like to
> have video going on device.

Well DSS is still using pdata based init because of the DT bindings
are not ready yet.

Regards,

Tony 
