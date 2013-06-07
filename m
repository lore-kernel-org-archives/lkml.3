Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3FGIaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:30:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47296 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGIaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:30:12 -0400
Date: Fri, 7 Jun 2013 10:30:07 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        John Stultz <john.stultz@linaro.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Gregory =?UTF-8?B?Q2zDqW1lbnQ=?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH v3 4/6] ARM: kirkwood: move device tree nodes to DT
 irqchip and clocksource
Message-ID: <20130607103007.415575c8@skate>
In-Reply-To: <1370536034-23956-5-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1370536034-23956-5-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Thu,  6 Jun 2013 18:27:12 +0200, Sebastian Hesselbarth wrote:

> -		wdt@20300 {
> +		wdt: watchdog-timer@20300 {
>  			compatible = "marvell,orion-wdt";
>  			reg = <0x20300 0x28>;
> +			interrupt-parent = <&bridge_intc>;
> +			interrupts = <3>;
>  			clocks = <&gate_clk 7>;
>  			status = "okay";
>  		};

The watchdog driver is mapping the same registers as the timer driver
(0x20300) and is poking into the same TIMER_CTRL register that controls
both the timers and the watchdog.

In addition to this, the watchdog driver also pokes into some other
registers, such as BRIDGE_CAUSE and RSTOUTn_MASK.

As we want to bring watchdog support for Armada 370/XP, I'm wondering
if we should fix those problems, and if yes, how:

 (1) The timer driver is also responsible for handling the watchdog
     (probably the easiest solution)

 (2) Have some sort of 'common code' between the timer driver and the
     watchdog driver to control the access to the shared TIMER_CTRL
     register.

 (3) Something else.

And this still does not solve the access to BRIDGE_CAUSE and
RSTOUTn_MASK.

Ideas?

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
