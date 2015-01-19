Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbbASO0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:26:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:35295 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbASO0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:26:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="514303051"
Message-ID: <54BD13F8.2040105@linux.intel.com>
Date: Mon, 19 Jan 2015 22:26:00 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 00/19] Improve ACPI resource parsing interfaces and
 data structures
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <2025625.5YhoBnTE03@vostro.rjw.lan>
In-Reply-To: <2025625.5YhoBnTE03@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/12 6:38, Rafael J. Wysocki wrote:
> On Thursday, January 08, 2015 10:32:47 AM Jiang Liu wrote:
>> During enabling ACPI based IOAPIC hotplug, Thomas noticed some issues
>> in ACPI resource parsing interfaces. So this is an effort to improve them.
>>
>> Patch 1-12 improve ACPI resource parsing interfaces and also fixes some
>> bugs.
>>
>> Patch 13-19 try to share the common data structure resource_list_entry
>> between PCI and ACPI. It may also be shared with PNP too.
> 
> I've looked at the patches briefly.
> 
> I like the changes at the general level, but there are some things I'm
> potentially concerned about in them.  Need more time to look at them,
> I'll do my best to do that this week while at the conference.
Hi Rafael,
	Thanks for your time. Any comments about this series?
Regards,
Gerry

> 
>> The patchset is based on v3.19-rc3 and you may get it from:
>> https://github.com/jiangliu/linux.git acpires_v1
>>
>> Jiang Liu (11):
>>   ACPI: Fix a bug in parsing ACPI Memroy24 resource
>>   ACPI: Normalize return value of resource parser functions
>>   ACPI: Set flag IORESOURCE_UNSET for unassigned resources
>>   ACPI: Enforce stricter checks for address space descriptors
>>   ACPI: Return translation offset when parsing ACPI address space
>>     resources
>>   ACPI: Translate resource into master side address for bridge window
>>     resources
>>   ACPI: Add field offset to struct resource_list_entry
>>   ACPI: Introduce helper function acpi_dev_filter_resource_type()
>>   resources: Move struct resource_list_entry from ACPI into resource
>>     core
>>   PCI: Use common resource list management code instead of private
>>     implementation
>>   x86/PCI/ACPI: Use common ACPI resource interfaces to simplify
>>     implementation
>>
>> Thomas Gleixner (8):
>>   ACPI: Remove redundant check in function
>>     acpi_dev_resource_address_space()
>>   ACPI: Implement proper length checks for mem resources
>>   ACPI: Use the length check for io resources as well
>>   ACPI: Let the parser return false for disabled resources
>>   ACPI: Provide union for address_space64 and ext_address_space64
>>   ACPI: Unify the parsing of address_space and ext_address_space
>>   ACPI: Move the window flag logic to the combined parser
>>   ACPI: Add prefetch decoding to the address space parser
>>
>>  arch/arm/kernel/bios32.c            |    5 +-
>>  arch/x86/pci/acpi.c                 |  297 ++++++++++---------------------
>>  arch/x86/pci/bus_numa.c             |    4 +-
>>  drivers/acpi/acpi_lpss.c            |    6 +-
>>  drivers/acpi/acpi_platform.c        |    2 +-
>>  drivers/acpi/resource.c             |  333 ++++++++++++++++++++++-------------
>>  drivers/dma/acpi-dma.c              |    8 +-
>>  drivers/pci/bus.c                   |   18 +-
>>  drivers/pci/host-bridge.c           |    8 +-
>>  drivers/pci/host/pci-host-generic.c |    4 +-
>>  drivers/pci/host/pci-xgene.c        |    4 +-
>>  drivers/pci/host/pcie-xilinx.c      |    4 +-
>>  drivers/pci/probe.c                 |   10 +-
>>  drivers/pnp/pnpacpi/rsparser.c      |    4 +-
>>  include/acpi/acrestyp.h             |   49 ++++--
>>  include/linux/acpi.h                |   12 +-
>>  include/linux/ioport.h              |   25 +++
>>  include/linux/pci.h                 |    8 +-
>>  kernel/resource.c                   |   48 +++++
>>  19 files changed, 452 insertions(+), 397 deletions(-)
>>
>>
> 
