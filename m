Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaEGU3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:29:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39137 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751174AbaEGU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:28:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/AEF9RMdG5YhK+2BGUTSmCnzbnNPhjTkQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan ACA2C56EC54
Date: Wed, 7 May 2014 16:28:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Kevin Hilman <khilman@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org,
        Corey Minyard <minyard@acm.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-build-reports@lists.linaro.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: IPMI misbehaving on ARM defconfigs, was [Re: stable boot: 18
 pass, 4 fail (v3.10.39)]
Message-ID: <20140507202841.GH28159@titan.lakedaemon.net>
References: <5369063f.4291420a.03aa.495e@mx.google.com>
 <20140507142056.GD28159@titan.lakedaemon.net>
 <10890279.Lp5U737Dmi@wuerfel>
 <20140507145656.GE28159@titan.lakedaemon.net>
 <7hioph2xfv.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hioph2xfv.fsf@paris.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:36:20PM -0700, Kevin Hilman wrote:
> Jason Cooper <jason@lakedaemon.net> writes:
> 
> > On Wed, May 07, 2014 at 04:44:42PM +0200, Arnd Bergmann wrote:
> >> On Wednesday 07 May 2014 10:20:56 Jason Cooper wrote:
> >> > > ipmi message handler version 39.2
> >> > > IPMI System Interface driver.
> >> > > ipmi_si: Adding default-specified kcs state machine
> >> > > ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> >> > > ipmi_si: Could not set up I/O space
> >> > > Trying to free nonexistent resource <0000000000000ca2-0000000000000ca2>
> >> > > Trying to free nonexistent resource <0000000000000ca3-0000000000000ca3>
> >> > > ipmi_si: Adding default-specified smic state machine
> >> > > ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> >> > > ipmi_si: Could not set up I/O space
> >> > > Trying to free nonexistent resource <0000000000000ca9-0000000000000ca9>
> >> > > Trying to free nonexistent resource <0000000000000caa-0000000000000caa>
> >> > > Trying to free nonexistent resource <0000000000000cab-0000000000000cab>
> >> > > ipmi_si: Adding default-specified bt state machine
> >> > > ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> >> > > ipmi_si: Could not set up I/O space
> >> > > Trying to free nonexistent resource <00000000000000e4-00000000000000e4>
> >> > > Trying to free nonexistent resource <00000000000000e5-00000000000000e5>
> >> > > Trying to free nonexistent resource <00000000000000e6-00000000000000e6>
> >> > > ipmi_si: Unable to find any System Interface(s)
> >> > > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> >> > ...
> >> > 
> >> > It appears to be unrelated to the failure this original message was
> >> > about.  However, the failure brought the above to our attention. 
> >> > 
> >> > Is the IPMI driver used on ARM?  Documentation/IPMI.txt indicates a
> >> > dependency on ACPI, but that isn't reflected in the Kconfig.  At any
> >> > rate, it seems rather unhappy.  :(
> >> 
> >> It certainly can be used, and it can be probed through a known PC-style
> >> port number or through the DT binding.
> >> 
> >> However, we don't normally want it to try the PC style addresses, which
> >> appear to be used in this case. This should only happen if
> >> CONFIG_IPMI_SI_PROBE_DEFAULTS is set, as far as I can tell. Is that
> >> set in your configuration?
> >
> > It's not set in multi_v7_defconfig, which is the config this failed
> > under.  At least not on linux-3.10.y.

Oops, I was wrong.  Not sure what happened to my grep-fu, but it is
clearly set in multi_v7_defconfig in linux-3.10.y.

> > Kevin, do you still have the full config from this build?  Could you
> > send us the IPMI related settings?
> 
> Below is the .config used for the multi_v7_defconfig build of v3.10.39

Awesome, thanks.  That confirms I was wrong :)

On a broader topic, if we have users in the field running v3.10.y on ARM
systems, then I think it's worth backporting the defconfig changes to
boot-test those systems.

I'll see if I can generate a list of patches.

thx,

Jason.
