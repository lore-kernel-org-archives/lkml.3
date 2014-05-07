Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbaEGOpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:45:00 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60104 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaEGOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:44:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Jason Cooper <jason@lakedaemon.net>,
        "Kevin's boot bot" <khilman@linaro.org>,
        Corey Minyard <minyard@acm.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-build-reports@lists.linaro.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: IPMI misbehaving on ARM defconfigs, was [Re: stable boot: 18 pass, 4 fail (v3.10.39)]
Date: Wed, 07 May 2014 16:44:42 +0200
Message-ID: <10890279.Lp5U737Dmi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140507142056.GD28159@titan.lakedaemon.net>
References: <5369063f.4291420a.03aa.495e@mx.google.com> <20140507142056.GD28159@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+A2QerkkUDKTEW9gKBSrkv3vY16CyUqe0h1WtFHNeFi
 IqE3Y/5npJrJYxqvl7dnrtYVvgScgJienWvuBeGE2saGworhwj
 0G6rEUB5SQYs/U0/ZrhwsHBwpl4vgGJEzr4sBtlNmxchGrv8fe
 ZY72iFFYsS7ZFaI4WIVp/FU5QpskYZHFfR1TqLpljvdDbTX2ND
 e3g+NqCdlPF52DRbvtMwllOF9BYZH/8t3QYcmY211XNb/onf+c
 4rQkPTk4XnosC3INkQjbQ45yL7yOABqQeQADXPlt4yu9+c9Xmj
 2C+DtAyYLSLS82/petzY5YAroB3gviRq+/4ZjJfw7vo8UBjiY5
 Bc1WFccBc6dCUA2MUHgY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 10:20:56 Jason Cooper wrote:
> > ipmi message handler version 39.2
> > IPMI System Interface driver.
> > ipmi_si: Adding default-specified kcs state machine
> > ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> > ipmi_si: Could not set up I/O space
> > Trying to free nonexistent resource <0000000000000ca2-0000000000000ca2>
> > Trying to free nonexistent resource <0000000000000ca3-0000000000000ca3>
> > ipmi_si: Adding default-specified smic state machine
> > ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> > ipmi_si: Could not set up I/O space
> > Trying to free nonexistent resource <0000000000000ca9-0000000000000ca9>
> > Trying to free nonexistent resource <0000000000000caa-0000000000000caa>
> > Trying to free nonexistent resource <0000000000000cab-0000000000000cab>
> > ipmi_si: Adding default-specified bt state machine
> > ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> > ipmi_si: Could not set up I/O space
> > Trying to free nonexistent resource <00000000000000e4-00000000000000e4>
> > Trying to free nonexistent resource <00000000000000e5-00000000000000e5>
> > Trying to free nonexistent resource <00000000000000e6-00000000000000e6>
> > ipmi_si: Unable to find any System Interface(s)
> > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> ...
> 
> It appears to be unrelated to the failure this original message was
> about.  However, the failure brought the above to our attention. 
> 
> Is the IPMI driver used on ARM?  Documentation/IPMI.txt indicates a
> dependency on ACPI, but that isn't reflected in the Kconfig.  At any
> rate, it seems rather unhappy.  :(

It certainly can be used, and it can be probed through a known PC-style
port number or through the DT binding.

However, we don't normally want it to try the PC style addresses, which
appear to be used in this case. This should only happen if
CONFIG_IPMI_SI_PROBE_DEFAULTS is set, as far as I can tell. Is that
set in your configuration?

	Arnd
