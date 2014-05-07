Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaEGPNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:13:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64171 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaEGPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:13:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18RP+HfmgATl5OqV14PgZAE7d/O0cR054w=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7590E56E56F
Date: Wed, 7 May 2014 11:12:59 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Corey Minyard <minyard@acm.org>
Cc: "Kevin's boot bot" <khilman@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: IPMI misbehaving on ARM defconfigs, was [Re: stable boot: 18
 pass, 4 fail (v3.10.39)]
Message-ID: <20140507151259.GF28159@titan.lakedaemon.net>
References: <5369063f.4291420a.03aa.495e@mx.google.com>
 <20140507142056.GD28159@titan.lakedaemon.net>
 <536A43BA.20105@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536A43BA.20105@acm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey,

On Wed, May 07, 2014 at 09:31:22AM -0500, Corey Minyard wrote:
> You probably don't have an IPMI controller on your system.  You can just
> remove the driver from the config.  Kernel 3.15 will have the default
> probing removed, and you won't see these messages any more.

ahh, here it is:

  0dfe6e7ed47f ipmi: Turn off default probing of interfaces

Since Arnd says it's possible to have this hardware on an ARM platform,
I think backporting this fix may be appropriate.

Although, it looks like the only ARM defconfig that selects this driver
is mini2440_defconfig.  So I'm uncertain how it gets turned on in
multi_v7_defconfig, particularly for the v3.10.y stable tree...

thx,

Jason.

> On 05/07/2014 09:20 AM, Jason Cooper wrote:
> > Cory, all,
> >
> > On our ARM boot farm, we've started seeing the following:
> >
> > On Tue, May 06, 2014 at 08:56:47AM -0700, Kevin's boot bot wrote:
> >> Tree/Branch: stable
> >> Git describe: v3.10.39
> >> Failed boot tests (console logs at the end)
> >> ===========================================
> >>                    da850-evm:     FAIL:    arm-davinci_all_defconfig
> >>   armada-xp-openblocks-ax3-4:     FAIL:    arm-multi_v7_defconfig
> >>           armada-370-mirabox:     FAIL:    arm-multi_v7_defconfig
> >>         sun4i-a10-cubieboard:     FAIL:    arm-multi_v7_defconfig
> >>
> > ...
> >> arm-multi_v7_defconfig
> >> ----------------------
> >>
> >> 	armada-xp-openblocks-ax3-4: FAIL: last 80 lines of boot log:
> >> 	------------------------------------------------------------
> >>
> >> pps_core: LinuxPPS API ver. 1 registered
> >> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> >> PTP clock support registered
> >> EDAC MC: Ver: 3.0.0
> >> Switching to clocksource armada_370_xp_clocksource
> >> bounce pool size: 64 pages
> >> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> >> io scheduler noop registered
> >> io scheduler deadline registered
> >> io scheduler cfq registered (default)
> >> armada-xp-pinctrl d0018000.pinctrl: registered pinctrl driver
> >> ipmi message handler version 39.2
> >> IPMI System Interface driver.
> >> ipmi_si: Adding default-specified kcs state machine
> >> ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> >> ipmi_si: Could not set up I/O space
> >> Trying to free nonexistent resource <0000000000000ca2-0000000000000ca2>
> >> Trying to free nonexistent resource <0000000000000ca3-0000000000000ca3>
> >> ipmi_si: Adding default-specified smic state machine
> >> ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> >> ipmi_si: Could not set up I/O space
> >> Trying to free nonexistent resource <0000000000000ca9-0000000000000ca9>
> >> Trying to free nonexistent resource <0000000000000caa-0000000000000caa>
> >> Trying to free nonexistent resource <0000000000000cab-0000000000000cab>
> >> ipmi_si: Adding default-specified bt state machine
> >> ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> >> ipmi_si: Could not set up I/O space
> >> Trying to free nonexistent resource <00000000000000e4-00000000000000e4>
> >> Trying to free nonexistent resource <00000000000000e5-00000000000000e5>
> >> Trying to free nonexistent resource <00000000000000e6-00000000000000e6>
> >> ipmi_si: Unable to find any System Interface(s)
> >> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > ...
> >
> > It appears to be unrelated to the failure this original message was
> > about.  However, the failure brought the above to our attention. :)
> >
> > Is the IPMI driver used on ARM?  Documentation/IPMI.txt indicates a
> > dependency on ACPI, but that isn't reflected in the Kconfig.  At any
> > rate, it seems rather unhappy.  :(
> >
> > thx,
> >
> > Jason.
> 
