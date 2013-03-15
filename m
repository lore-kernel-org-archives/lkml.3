Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3COJU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:20:56 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33465 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:20:52 -0400
Message-ID: <5142E7F0.4020002@gmail.com>
Date: Fri, 15 Mar 2013 10:20:48 +0100
From: Harald Arnesen <skogtun.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the same problem on my Lenovo T500. I think the graphics card is
involved.

This laptop has "hybrid graphics" - one Intel GMA 4500MHD and one ATI
Mobility Radeon HD 3650. When I boot with the Intel card, I get "irq 16:
nobody cared" during boot, not when I boot with the ATI card.

And /proc/interrupts are surely different with the two cards. Look at
the irq 16 line:

$ cat intel-interrupts.txt
           CPU0       CPU1
  0:      23658      22859   IO-APIC-edge      timer
  1:        168        177   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:        329        347   IO-APIC-fasteoi   acpi
 12:       3065       3166   IO-APIC-edge      i8042
 16:      49732      50269   IO-APIC-fasteoi   yenta, uhci_hcd:usb6
 17:          1          0   IO-APIC-fasteoi   firewire_ohci, uhci_hcd:usb7
 18:          0          0   IO-APIC-fasteoi   mmc0, uhci_hcd:usb8
 19:        216        204   IO-APIC-fasteoi   ehci_hcd:usb2
 20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 21:        114        103   IO-APIC-fasteoi   uhci_hcd:usb4
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 23:          9          9   IO-APIC-fasteoi   i801_smbus, ehci_hcd:usb1
 40:          0          0  DMAR_MSI-edge      dmar2
 41:          0          0  DMAR_MSI-edge      dmar0
 42:          0          0  DMAR_MSI-edge      dmar3
 43:          0          0   PCI-MSI-edge      PCIe PME
 44:          0          0   PCI-MSI-edge      PCIe PME
 45:          0          0   PCI-MSI-edge      PCIe PME
 46:          0          0   PCI-MSI-edge      PCIe PME
 47:      10023      10173   PCI-MSI-edge      ahci
 48:         10          8   PCI-MSI-edge      mei
 49:         22         30   PCI-MSI-edge      eth0
 50:         66         71   PCI-MSI-edge      i915
 51:       2508       2348   PCI-MSI-edge      iwlwifi
 52:        168        169   PCI-MSI-edge      snd_hda_intel
NMI:         17         17   Non-maskable interrupts
LOC:      27988      25243   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:         17         17   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:       4584       2746   Rescheduling interrupts
CAL:       6178       7492   Function call interrupts
TLB:        702        651   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          1          1   Machine check polls
ERR:          0
MIS:          0

$ cat ati-interrupts.txt
           CPU0       CPU1
  0:      15488      15268   IO-APIC-edge      timer
  1:        182        189   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc0
  9:        328        339   IO-APIC-fasteoi   acpi
 12:       2071       1997   IO-APIC-edge      i8042
 16:         55         47   IO-APIC-fasteoi   yenta, uhci_hcd:usb4
 17:          1          1   IO-APIC-fasteoi   firewire_ohci, uhci_hcd:usb5
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb6, mmc0
 19:        219        202   IO-APIC-fasteoi   ehci_hcd:usb8
 20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb1
 21:        112        104   IO-APIC-fasteoi   uhci_hcd:usb2
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:         10          8   IO-APIC-fasteoi   i801_smbus, ehci_hcd:usb7
 40:          0          0  DMAR_MSI-edge      dmar1
 41:          0          0  DMAR_MSI-edge      dmar0
 42:          0          0  DMAR_MSI-edge      dmar2
 43:          0          0   PCI-MSI-edge      PCIe PME
 44:          0          0   PCI-MSI-edge      PCIe PME
 45:          0          0   PCI-MSI-edge      PCIe PME
 46:          0          0   PCI-MSI-edge      PCIe PME
 47:          0          0   PCI-MSI-edge      PCIe PME
 48:       9733       9932   PCI-MSI-edge      ahci
 49:          9          9   PCI-MSI-edge      mei
 50:       2308       2196   PCI-MSI-edge      iwlwifi
 51:         15         35   PCI-MSI-edge      eth0
 52:        818        815   PCI-MSI-edge      radeon
 53:        167        167   PCI-MSI-edge      snd_hda_intel
NMI:         17         16   Non-maskable interrupts
LOC:      18139      34223   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:         17         16   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RTR:          0          0   APIC ICR read retries
RES:       3788       3563   Rescheduling interrupts
CAL:       6303       5894   Function call interrupts
TLB:        711        711   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          1          1   Machine check polls
ERR:          0
MIS:          0
-- 
Hilsen Harald
