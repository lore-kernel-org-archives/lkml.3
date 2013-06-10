Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3FJR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:26:17 -0400
Received: from londo.lunn.ch ([80.238.139.98]:38830 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3FJR0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:26:16 -0400
Date: Mon, 10 Jun 2013 19:25:41 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] clocksource: add Marvell Orion SoC timer
Message-ID: <20130610172541.GA21290@lunn.ch>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1370856955-10514-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370856955-10514-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:35:55AM +0200, Sebastian Hesselbarth wrote:
> This patch add a DT enabled driver for timers found on Marvell Orion SoCs
> (Kirkwood, Dove, Orion5x, and Discovery Innovation). It installs a free-
> running clocksource on timer0 and a clockevent source on timer1.
> Corresponding device tree documentation is also added.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v3->v4:
> - export thread-safe access to TIMER_CTRL register to use with watchdog
> - remove IRQF_DISABLED and add .irq to clock event (Suggested by Daniel Lezcano)
> 
> Notes:
> - This is only an update to clocksource driver, the remaining patches are
>   not resent as they have not been changed.
> - I will not rework orion watchdog driver for this patch set. It is written
>   Kirkwood/Orion5x specific although it will also work on Dove and it is messing
>   with shared registers. It has done it before, so I consider it broken anyway.
>   I (or somebody else) will take care of proper watchdog later.
> - An updated branch can be found on
>   git://github.com/shesselba/linux-dove.git orion-irqchip-for-v3.11_v4

Hi Sebastian

You can add a

Tested-by: Andrew Lunn <andrew@lunn.ch>

I tested on my kirkwood QNAP.

           CPU0
  2:       6062  bridge-interrupt-ctrl  orion_event
  9:          0  f1010140.gpio  Reset
 15:          0  f1010140.gpio  USB Copy
 24:        106  main-interrupt-ctrl  ehci_hcd:usb1
 25:       2463  main-interrupt-ctrl  sata_mv
 26:          0  main-interrupt-ctrl  f1030000.crypto
 27:          2  main-interrupt-ctrl  f1060800.xor
 28:          2  main-interrupt-ctrl  f1060800.xor
 29:         71  main-interrupt-ctrl  mv64xxx_i2c
 30:          2  main-interrupt-ctrl  f1060900.xor
 31:          2  main-interrupt-ctrl  f1060900.xor
 32:         41  main-interrupt-ctrl  eth0
 33:       1317  main-interrupt-ctrl  serial
 75:        745  main-interrupt-ctrl  f1072004.mdio-bus
Err:          0                                              

      Andrew
