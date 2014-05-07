Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbaEGO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:57:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27515 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaEGO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:57:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/fG/9meFk+b6LxL8499NDryMo8b7FNByo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 68D9C56E51C
Date: Wed, 7 May 2014 10:56:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, "Kevin's boot bot" <khilman@linaro.org>,
        Corey Minyard <minyard@acm.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-build-reports@lists.linaro.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: IPMI misbehaving on ARM defconfigs, was [Re: stable boot: 18
 pass, 4 fail (v3.10.39)]
Message-ID: <20140507145656.GE28159@titan.lakedaemon.net>
References: <5369063f.4291420a.03aa.495e@mx.google.com>
 <20140507142056.GD28159@titan.lakedaemon.net>
 <10890279.Lp5U737Dmi@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10890279.Lp5U737Dmi@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:44:42PM +0200, Arnd Bergmann wrote:
> On Wednesday 07 May 2014 10:20:56 Jason Cooper wrote:
> > > ipmi message handler version 39.2
> > > IPMI System Interface driver.
> > > ipmi_si: Adding default-specified kcs state machine
> > > ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> > > ipmi_si: Could not set up I/O space
> > > Trying to free nonexistent resource <0000000000000ca2-0000000000000ca2>
> > > Trying to free nonexistent resource <0000000000000ca3-0000000000000ca3>
> > > ipmi_si: Adding default-specified smic state machine
> > > ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> > > ipmi_si: Could not set up I/O space
> > > Trying to free nonexistent resource <0000000000000ca9-0000000000000ca9>
> > > Trying to free nonexistent resource <0000000000000caa-0000000000000caa>
> > > Trying to free nonexistent resource <0000000000000cab-0000000000000cab>
> > > ipmi_si: Adding default-specified bt state machine
> > > ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> > > ipmi_si: Could not set up I/O space
> > > Trying to free nonexistent resource <00000000000000e4-00000000000000e4>
> > > Trying to free nonexistent resource <00000000000000e5-00000000000000e5>
> > > Trying to free nonexistent resource <00000000000000e6-00000000000000e6>
> > > ipmi_si: Unable to find any System Interface(s)
> > > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> > ...
> > 
> > It appears to be unrelated to the failure this original message was
> > about.  However, the failure brought the above to our attention. 
> > 
> > Is the IPMI driver used on ARM?  Documentation/IPMI.txt indicates a
> > dependency on ACPI, but that isn't reflected in the Kconfig.  At any
> > rate, it seems rather unhappy.  :(
> 
> It certainly can be used, and it can be probed through a known PC-style
> port number or through the DT binding.
> 
> However, we don't normally want it to try the PC style addresses, which
> appear to be used in this case. This should only happen if
> CONFIG_IPMI_SI_PROBE_DEFAULTS is set, as far as I can tell. Is that
> set in your configuration?

It's not set in multi_v7_defconfig, which is the config this failed
under.  At least not on linux-3.10.y.

Kevin, do you still have the full config from this build?  Could you
send us the IPMI related settings?

thx,

Jason.
