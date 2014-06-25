Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaF0OYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:24:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39921 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaF0OXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:23:54 -0400
Date: Wed, 25 Jun 2014 10:44:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 00/16] Enable support of IOAPIC hotplug on x86
 platforms
Message-ID: <20140625144442.GA3775@laptop.dumpdata.com>
References: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403685648-10103-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:40:31PM +0800, Jiang Liu wrote:
> This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
> hotplug on x86 platforms. It's based on tip/x86/apic.
> 
> You may pull it from 
> https://github.com/jiangliu/linux.git ioapic/hotplug_v3

fatal: Couldn't find remote ref ioapic/hotplug_v3
Unexpected end of command stream

I see ioapic/hotplug_v2?
> 
> We have pick up several patches from Yinghai's original IOAPIC hotplug
> patch set and reimplemented IOAPIC driver as an ACPI driver instead of
> a PCI driver.
> 
> It has been tested on a 4-socket Intel SDV with socket hot-addition
> capability. Any suggestions are welcomed!
> 
> Patch 1-5 are minor bugfixes and code improvements
> Patch 6-14 enhances ACPI and IOAPIC core to support IOAPIC hotplug
> Patch 15 killes PCI IOAPIC driver
> Patch 16 reimplements ACPI IOAPIC driver and enables IOAPIC hotplug
> 
> V2->V3:
> 1) Refine ACPI resource walk functions for PCI root bus and IOAPIC
> 2) Improve commit messages
> 3) Reorder patch order for better maintenence
> 
> Jiang Liu (11):
>   x86, irq, ACPI: Protect acpi_pci_irq_enable() from reentrance
>   ACPI: Correct return value of acpi_dev_resource_address_space()
>   x86, PCI, ACPI: Kill private function resource_to_addr()
>   x86, irq: Remove __init marker for functions will be used by IOAPIC
>     hotplug
>   x86, irq: Refine mp_register_ioapic() to prepare for IOAPIC hotplug
>   x86, irq, ACPI: Introduce a rwsem to protect IOAPIC operations from
>     hotplug
>   x86, irq, ACPI: Implement interface to support ACPI based IOAPIC
>     hot-addition
>   x86, irq, ACPI: Implement interface to support ACPI based IOAPIC
>     hot-removal
>   x86, irq: Introduce helper to check whether an IOAPIC has been
>     registered
>   PCI: Remove PCI ioapic driver
>   x86, irq, ACPI: Implement ACPI driver to support IOAPIC hotplug
> 
> Yinghai Lu (5):
>   ACPI: Make map_mat_entry handle x2apic entry
>   ACPI: Move acpi_get_cpuid() to separated file
>   x86, irq: Split out alloc_ioapic_save_registers()
>   x86, ioapic: Find usable ioapic id for 64bit.
>   ACPI, ioapic: Add acpi_get_ioapic_id()
> 
>  arch/x86/include/asm/io_apic.h |    6 +-
>  arch/x86/kernel/acpi/boot.c    |   68 ++++++++-
>  arch/x86/kernel/apic/io_apic.c |  235 +++++++++++++++++++++++++-------
>  arch/x86/pci/acpi.c            |  142 +++++++------------
>  drivers/acpi/Kconfig           |    6 +
>  drivers/acpi/Makefile          |    2 +
>  drivers/acpi/apic_id.c         |  295 ++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/internal.h        |    7 +
>  drivers/acpi/ioapic.c          |  236 ++++++++++++++++++++++++++++++++
>  drivers/acpi/pci_irq.c         |    7 +-
>  drivers/acpi/pci_root.c        |    3 +
>  drivers/acpi/processor_core.c  |  191 --------------------------
>  drivers/acpi/resource.c        |    2 +-
>  drivers/pci/Kconfig            |    7 -
>  drivers/pci/Makefile           |    2 -
>  drivers/pci/ioapic.c           |  121 ----------------
>  include/acpi/processor.h       |    3 -
>  include/linux/acpi.h           |    8 ++
>  18 files changed, 868 insertions(+), 473 deletions(-)
>  create mode 100644 drivers/acpi/apic_id.c
>  create mode 100644 drivers/acpi/ioapic.c
>  delete mode 100644 drivers/pci/ioapic.c
> 
> -- 
> 1.7.10.4
> 
