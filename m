Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab3FSMcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:32:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14862 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSMcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:32:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+E8EJvGmk/ifnBdkiDe2gT
Date: Wed, 19 Jun 2013 05:32:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: florian.vaussard@epfl.ch, Roger Quadros <rogerq@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
Message-ID: <20130619123217.GB5523@atomide.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
 <1371571487-14389-2-git-send-email-rogerq@ti.com>
 <51C106A1.9030001@ti.com>
 <51C15F7E.5020305@ti.com>
 <20130619074605.GW5523@atomide.com>
 <51C183AC.8040801@ti.com>
 <51C19011.5050107@ti.com>
 <51C19E6C.4040802@epfl.ch>
 <51C1A2AE.2020506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C1A2AE.2020506@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benoit Cousson <b-cousson@ti.com> [130619 05:30]:
> On 06/19/2013 07:05 AM, Florian Vaussard wrote:
> >>>>>>>+
> >>>>>>>+    /* HS USB Port 1 RESET */
> >>>>>>>+    hsusb1_reset: hsusb1_reset_reg {
> >>>>>>>+        compatible = "regulator-fixed";
> >>>>>>>+        regulator-name = "hsusb1_reset";
> >>>>>>>+        regulator-min-microvolt = <3300000>;
> >>>>>>>+        regulator-max-microvolt = <3300000>;
> >>>>>>>+        gpio = <&gpio2 30 0>;    /* gpio_62 */
> >>>>>>>+        startup-delay-us = <70000>;
> >>>>>>>+        enable-active-high;
> >>>>>>>+    };
> >>>>>>
> >>>>>>Is this really a regulator? Or just a GPIO line used to reset the
> >>>>>>USB PHY?
> >>>>>
> >>>>>It is in fact a GPIO line used as reset.
> >>>>>>
> >>>>>>If this is the case, I don't think it should be represented as a
> >>>>>>regulator.
> >>>>>
> >>>>>Why not? I think it fits very well in the regulator device model.
> >>>
> >>>I'm not sure fitting very well is the correct term.
> >>>It works, for sure, but it is no different than when we were trying
> >>>to abuse the regulator fmwk to enable the 32k clock in phoenix.
> >>>It is just a hack.

If it's a reset, then yeah it's not a regulator. If the GPIO line is
really used to control the regulator in the external device, then it
makes sense to set it up as a regulator.

> >>The only difference is there is a dedicated framework for clocks.
> >>Since there is nothing specific to
> >>handle reset lines it is left to the driver writer how he wants to
> >>manage it.
> >>
> >
> >There is a proposed binding for gpio-controlled reset lines, but it is
> >not yet merged [1].
> >I guess it can fit most usage patterns, and it can be an interesting
> >move in the future.
> 
> I'm glad to see that I was not the only one thinking that the
> regulator was not the right fmwk to do that :-)
> 
> Thanks for the pointer Florian.

Good to hear about the gpio-controlled reset lines :)
 
> I guess that series should be merged for 3.11? Based on the thread,
> it should to through arm-soc.
> 
> Roger,
> 
> It might be tricky to have dependency on that series, but if this is
> possible, you should try. Otherwise, just keep the existing one,
> adding that a new solution will be available soon as a disclaimer.

We need some solution for v3.11 for omap4 USB on panda so people can
use it with DT.

Regards,

Tony
