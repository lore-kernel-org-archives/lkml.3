Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaGVMPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:15:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:59991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaGVMNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:50 -0400
Date: Tue, 22 Jul 2014 14:13:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the
 "freeze" sleep state
Message-ID: <20140722121345.GC3935@laptop>
References: <1907495.agrCMfRsQN@vostro.rjw.lan>
 <9631666.En3K0jlGsY@vostro.rjw.lan>
 <20140722085538.GA3935@laptop>
 <2866134.Da8PQoU0sW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2866134.Da8PQoU0sW@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:23:03PM +0200, Rafael J. Wysocki wrote:
> > Doesn't break, doesn't 'work' either.
> 
> This probably means that WoL on that machine is not ACPI-based.

Oh lovely, of course that's an 'option' !

> > Is there anything I can provide you with to make this easier? lspci output
> > or anything like that?
> 
> Yes, /proc/interrupts from the machine in question would help to start with.

Be sure to get a _wide_ terminal when viewing ;-)

            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       CPU8       CPU9       CPU10      CPU11      CPU12      CPU13      CPU14      CPU15      CPU16      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23      
   0:        433          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      timer
   1:          3          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      i8042
   3:          4          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge    
   4:        357          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      serial
   8:          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      rtc0
   9:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-fasteoi   acpi
  12:          4          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC-edge      i8042
  16:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC   16-fasteoi   pata_jmicron, uhci_hcd:usb3
  18:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC   18-fasteoi   ehci_hcd:usb1, uhci_hcd:usb7, i801_smbus
  19:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC   19-fasteoi   uhci_hcd:usb4, uhci_hcd:usb6
  23:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IO-APIC   23-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5
  25:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
  27:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
  29:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
  31:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
  33:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      aerdrv, PCIe PME
  34:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      PCIe PME
  35:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      PCIe PME
  36:       2039          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      ahci
  37:          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0
  38:       6467          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-0
  39:       5504          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-1
  40:       5298          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-2
  41:       5221          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-3
  42:       6415          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-4
  43:       5311          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-5
  44:       5231          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-6
  45:       5556          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   PCI-MSI-edge      eth0-TxRx-7
 NMI:          8          1          1          0          0          0          0          0          7          0          0          2          0          3          1          0          0          0          0          2          0          0          0          1   Non-maskable interrupts
 LOC:      37022      15954      12352      10360      10326       9371       9760       9739      13134      11383      10975      11614       8692      15659      10999       9948       8597       8485      10011      15927      10431      10164       8530      10337   Local timer interrupts
 SPU:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Spurious interrupts
 PMI:          8          1          1          0          0          0          0          0          7          0          0          2          0          3          1          0          0          0          0          2          0          0          0          1   Performance monitoring interrupts
 IWI:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   IRQ work interrupts
 RTR:         15          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   APIC ICR read retries
 RES:       1150        345        168         73         60         66         92         70        243         60         54         54         35        108         66         35         32         36         41        286         60         37         46         55   Rescheduling interrupts
 CAL:         49         68         76         76         76         76        173        141        160        197        169        146         73         73         73         73         73         73         76        254         90        167         83         79   Function call interrupts
 TLB:          0          0          0          0          0          0          0          0          1          1          0          0          1          0          0          0          0          0          0          3          1          0          1          0   TLB shootdowns
 TRM:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Thermal event interrupts
 THR:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Machine check exceptions
 MCP:         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36         36   Machine check polls
 ERR:          0
 MIS:          0

> Also /sys/kernel/debug/wakeup_sources (if /sys/kernel/debug/ is where your debugfs
> lives) before

of course not, that's /debug :-)

name		active_count	event_count	wakeup_count	expire_count	active_since	total_time	max_time	last_change	prevent_suspend_time
00:06       	0		0		0		0		0		0		0		7066		0
00:02       	0		0		0		0		0		0		0		7056		0
0000:00:1d.2	0		0		0		0		0		0		0		7056		0
0000:00:1d.1	0		0		0		0		0		0		0		7046		0
0000:00:1d.0	0		0		0		0		0		0		0		7035		0
0000:00:1a.2	0		0		0		0		0		0		0		7025		0
0000:00:1a.0	0		0		0		0		0		0		0		7015		0
0000:00:1d.7	0		0		0		0		0		0		0		7004		0
0000:00:1a.7	0		0		0		0		0		0		0		6982		0
0000:01:00.1	0		0		0		0		0		0		0		6797		0
0000:01:00.0	0		0		0		0		0		0		0		6591		0
alarmtimer  	0		0		0		0		0		0		0		5012		0
PNP0C0C:00  	0		0		0		0		0		0		0		1924		0
PNP0C0E:00  	0		0		0		0		0		0		0		1924		0
LNXPWRBN:00 	0		0		0		0		0		0		0		1922		0
PNP0A08:00  	0		0		0		0		0		0		0		1838		0
device:2a   	0		0		0		0		0		0		0		1802		0
device:29   	0		0		0		0		0		0		0		1798		0
device:10   	0		0		0		0		0		0		0		1763		0
device:02   	0		0		0		0		0		0		0		1757		0
device:00   	0		0		0		0		0		0		0		1746		0
device:01   	0		0		0		0		0		0		0		1735		0
device:15   	0		0		0		0		0		0		0		1730		0
device:13   	0		0		0		0		0		0		0		1723		0
device:12   	0		0		0		0		0		0		0		1718		0
device:11   	0		0		0		0		0		0		0		1711		0
device:1f   	0		0		0		0		0		0		0		1705		0
device:1b   	0		0		0		0		0		0		0		1699		0
device:19   	0		0		0		0		0		0		0		1693		0
device:18   	0		0		0		0		0		0		0		1685		0
device:16   	0		0		0		0		0		0		0		1678		0
device:28   	0		0		0		0		0		0		0		1616		0
device:26   	0		0		0		0		0		0		0		1612		0
device:24   	0		0		0		0		0		0		0		1607		0
device:22   	0		0		0		0		0		0		0		1602		0
device:20   	0		0		0		0		0		0		0		1597		0

> and after a "freeze" with an attempt to use WoL to wake it up.

Issued 3 WoLs then hit the power button:

name		active_count	event_count	wakeup_count	expire_count	active_since	total_time	max_time	last_change	prevent_suspend_time
00:06       	0		0		0		0		0		0		0		7066		0
00:02       	0		0		0		0		0		0		0		7056		0
0000:00:1d.2	0		0		0		0		0		0		0		7056		0
0000:00:1d.1	0		0		0		0		0		0		0		7046		0
0000:00:1d.0	0		0		0		0		0		0		0		7035		0
0000:00:1a.2	0		0		0		0		0		0		0		7025		0
0000:00:1a.0	0		0		0		0		0		0		0		7015		0
0000:00:1d.7	0		0		0		0		0		0		0		7004		0
0000:00:1a.7	0		0		0		0		0		0		0		6982		0
0000:01:00.1	0		0		0		0		0		0		0		6797		0
0000:01:00.0	0		0		0		0		0		0		0		6591		0
alarmtimer  	0		0		0		0		0		0		0		5012		0
PNP0C0C:00  	0		0		0		0		0		0		0		1924		0
PNP0C0E:00  	0		0		0		0		0		0		0		1924		0
LNXPWRBN:00 	1		1		0		0		0		0		0		10597988		0
PNP0A08:00  	0		0		0		0		0		0		0		1838		0
device:2a   	0		0		0		0		0		0		0		1802		0
device:29   	0		0		0		0		0		0		0		1798		0
device:10   	0		0		0		0		0		0		0		1763		0
device:02   	0		0		0		0		0		0		0		1757		0
device:00   	0		0		0		0		0		0		0		1746		0
device:01   	0		0		0		0		0		0		0		1735		0
device:15   	0		0		0		0		0		0		0		1730		0
device:13   	0		0		0		0		0		0		0		1723		0
device:12   	0		0		0		0		0		0		0		1718		0
device:11   	0		0		0		0		0		0		0		1711		0
device:1f   	0		0		0		0		0		0		0		1705		0
device:1b   	0		0		0		0		0		0		0		1699		0
device:19   	0		0		0		0		0		0		0		1693		0
device:18   	0		0		0		0		0		0		0		1685		0
device:16   	0		0		0		0		0		0		0		1678		0
device:28   	0		0		0		0		0		0		0		1616		0
device:26   	0		0		0		0		0		0		0		1612		0
device:24   	0		0		0		0		0		0		0		1607		0
device:22   	0		0		0		0		0		0		0		1602		0
device:20   	0		0		0		0		0		0		0		1597		0


