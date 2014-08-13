Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaHMPaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:30:30 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:40674 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaHMPa0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Wed, 13 Aug 2014 11:30:26 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2014 11:30:26 EDT
Message-Id: <53EB9EC9020000A100016A4D@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 13 Aug 2014 17:22:17 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Some problems with HP DL380 G8 BIOS and SLES11 SP3
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Running the current SLES11 SP3 kernel on a HP DL380 G8 server, there are some kernel messages that indicate a bug either in the kernel or in the HP BIOS. Maybe someone can explain, so I can try to get it fixed whatever party broke it...

Linux kernel is "3.0.101-0.35-default (geeko@buildhost) (gcc version 4.3.4 [gcc-4_3-branch revision 152973]" (latest).
HP server is "HP ProLiant DL380p Gen8, BIOS P70 02/10/2014" (latest)

During ACPI init I see:
[...]
Reserving 128MB of memory at 752MB for crashkernel (System RAM: 132095MB)
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 00000000bddaed00 000D4 (v01 HP     ProLiant 00000002   322? 0000162E)
ACPI: FACP 00000000bddaee40 000F4 (v03 HP     ProLiant 00000002   322? 0000162E)
ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (2011041
3/tbfadt-611)
ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20110413/
tbfadt-611)
ACPI: DSDT 00000000bddaef40 026DC (v01 HP         DSDT 00000001 INTL 20030228)
ACPI: FACS 00000000bddac140 00040
ACPI: SPCR 00000000bddac180 00050 (v01 HP     SPCRRBSU 00000001   322? 0000162E)
ACPI: MCFG 00000000bddac200 0003C (v01 HP     ProLiant 00000001      00000000)
[...]

HPET id 0 under DRHD base 0xf4ffe000
BIOS requests to not use x2apic
Use 'intremap=no_x2apic_optout' to override BIOS request
Enabled IRQ remapping in xapic mode
x2apic not enabled, IRQ remapping is in xapic mode
Switched APIC routing to physical flat.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU E5-2630 v2 @ 2.60GHz stepping 04
Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Broken BIOS detec
ted, complain to your hardware vendor.
[Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
[...]

 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x00
ACPI _OSC control for PCIe not granted, disabling ASPM
[...]

 pci0000:20: Requesting ACPI _OSC control (0x1d)
 pci0000:20: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x00
ACPI _OSC control for PCIe not granted, disabling ASPM
[...]

Regards,
Ulrich
P.S. Please CC: me, as I'm not on LKML...


