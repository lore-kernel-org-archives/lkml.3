Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3F0Op5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:45:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49641 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777Ab3F0Opj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:45:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2AX/851ZQ0pfA61EHmD9A
Date: Thu, 27 Jun 2013 07:45:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
Message-ID: <20130627144535.GK5523@atomide.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
 <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
 <20130625065811.GZ5523@atomide.com>
 <51CAEA90.90200@ti.com>
 <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
 <51CC45D3.2000305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC45D3.2000305@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130627 07:12]:
> 
> As you can see, from 12 pins only 3 pins need to be reconfigured
> while switching from "active"->"idle" states and back (and as I
> mentioned above for OMAP "idle" == "sleep" now).
> 
> Regarding "OFF" state:
> OMAP mux HW defines special state for unused pins which is selected
> by default after reset and need to be selected when device isn't
> used, for example:
> _MUXMODE - Functional multiplexing selection for pad
> 0x0: Select usbb1_hsic_data
> 0x3: Select gpio_96
> 0x7: Select safe_mode <<--- pin unused

The off mode bits can be enabled continuously, the mux hardware
automatically sets them. So sounds like you don't need any
separate "idle" "sleep" and "off" states, the following should
do:

"default" (or "static")	static pins that don't need to be touched
			after consumer driver probe

"active"		dynamic pins that are not a subset of
			"default" needed for runtime; these pins
			are the same as "idle" below, but with
			different muxing or pinconf device
			runtime

"idle"			dynamic pins that are not a subset of
			"default" needed for various idle modes;
			these pins are the same as "active" above,
			but with different muxing or pinconf for
			various idle states

Can you please confirm that these named modes are enough for
your needs?

If your hardware does not have specific off mode bits, then
I can understand that you may need one mor state "off".

Regards,

Tony
