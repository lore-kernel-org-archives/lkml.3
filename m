Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaICSpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:45:39 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47832 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaICSph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:45:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gLl+h+npMpyqPzzuzNh/9
Date: Wed, 3 Sep 2014 11:45:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>, linux-omap@vger.kernel.org
Subject: Re: PROBLEM: bindings for drivers/mfd/twl4030-power.c
Message-ID: <20140903184527.GG11766@atomide.com>
References: <FAC7D7E5-1D05-4D63-821F-C56D3AAA8FF9@goldelico.com>
 <20140825212652.GR17254@atomide.com>
 <EBD1E2E6-E596-4B3D-B093-144ABDD7DEDE@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EBD1E2E6-E596-4B3D-B093-144ABDD7DEDE@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. H. Nikolaus Schaller <hns@goldelico.com> [140901 09:54]:
> Hi,
> 
> Am 25.08.2014 um 23:26 schrieb Tony Lindgren:
> 
> > * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140817 08:46]:
> >> I am trying to make ti,use_poweroff work on 3.17-rc1 for the GTA04 board.
> >> Poweroff was broken for a while and I found that the driver isn't loaded at all.
> >> 
> >> It appears to me that commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
> >> did rename the compatible entry from "ti,twl4030-power" to "ti,twl4030-power-reset"
> >> but this was not documented in the bindings and of course our DT does not
> >> match.
> >> 
> >> Even your commit message talks about "ti,twl4030-power" although I can't find it
> >> in the code.
> > 
> > Hmm sorry did I accidentally remove ti,twl4030-power? If so, that should
> > be added back for sure. Do you have a patch for that already?
> 
> No, I have only updated our device tree because I don't know if it really should
> be added back or not.
> 
> As you say the "ti,twl4030-power" does not configure anything. So what
> is it good for?

Only for the poweroff if "ti,use_poweroff" is set. Care to do a patch
as you clearly have a use case to test it with?

> >> Are "ti,twl4030-power" and "ti,twl4030-power-reset" doing the same?
> > 
> > No, they are separate where ti,twl4030-power does not configure the
> > twl4030 in any way where ti,twl4030-power-reset configures the warm
> > reset sequence.
> 
> Yes, that is what I deduced because our old setting of "ti,twl4030-power" did
> no longer configure the power-off and not even load the driver.
> 
> > 
> > For gta04, what you really want is to use ti,twl4030-power-idle or
> > even ti,twl4030-power-idle-osc-off if the board is wired to support
> > cutting off the oscillator.
> 
> Ok, I see (but must admit that I don't understand the details even after
> reading the bindings.txt).

Well the twl4030 has resources such as GPIO pins and regulators that can
be configured to automatically change state for retention and off-idle.
That's how we can cut off the core voltage for idle.
 
> Currently we develop without taking care of suspend (the DT migration was
> much more troublesome work than anticipated) but that should be changed soon.

OK, yeah the PM features should be finally working now with mainline
and DT :)
 
> > And you probably also want to configure some wake-up interrupts at least
> > for the the UARTs in the board specific .dts file, see for example the
> > UART3 in the existing board files that have:
> > 
> > interrupts-extended = <&intc 74 &omap3_pmx_core OMAP3_UART3_RX>;
> 
> thanks for the hint!

No problem. And FYI, the reason why we can't add that automatically is
because there are alternate pins for UART3 pins depending on the
packaging and which pin is actually wired up.

Regards,

Tony
