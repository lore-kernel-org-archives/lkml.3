Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaFJOdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:33:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38413 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaFJOdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:33:13 -0400
Message-ID: <539716F7.1020901@ti.com>
Date: Tue, 10 Jun 2014 10:32:23 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
References: <1401297293-3950-1-git-send-email-m-karicheri2@ti.com> <20140530154455.GC4607@google.com>
In-Reply-To: <20140530154455.GC4607@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/2014 11:44 AM, Bjorn Helgaas wrote:
> On Wed, May 28, 2014 at 01:14:53PM -0400, Murali Karicheri wrote:
>> Call pcie_bus_configure_settings on ARM, like for other platforms.
>> pcie_bus_configure_settings makes sure the MPS across the bus is
>> uniform and provides the ability to tune the MRSS and MPS to higher
>> performance values. This is particularly important for embedded where
>> there is no firmware to program these PCI-E settings for the OS.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> I applied this to pci/misc for v3.16.  Russell, let me know if you object
> or prefer another route, and I can drop it.  I tweaked the changelog but
> didn't touch the actual patch, so I think git will do the right thing if it
> arrives via two trees.
Bjorn,

I checked git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git 
pci/misc branch
I don't see it. Is it a different repo?

I see the following commits, but not this.

a43ae58c848cfbadaba81c8d63202b4487f922a0 PCI: Turn 
pcibios_penalize_isa_irq() into a weak function
78916b00f0096059c872f537306b1a464c84fb30 PCI: Test for std config alias 
when testing extended config space
9edbcd2252b5ef148177c9f2c11a56469cf5db52 PCI: Remove 
pcibios_add_platform_entries()
ef4858c64e836b0b9dbdb9ece13ce932d9fcd4ad s390/pci: use pdev->dev.groups 
for attribute creation
dfc73e7acd9925b434a355eeeed86d44cb435f9c PCI: Move Open Firmware devspec 
attribute to PCI common code
1e358f94c00570f88a590cabe718daf835440cc9 PCI: Fix use of uninitialized 
MPS value
efdd4070f38e962d69c11f23c5aa033121a8cf0f PCI: Remove dead code
cad01f9191226f069a0932a01b738bacde784a62 MAINTAINERS: Add 
arch/x86/kernel/quirks.c to PCI file patterns
10874f5a00266343a06e95da680e8a5a383d9a80 PCI: Remove unnecessary __ref 
annotations
8895d3bcb8ba960b1b83f95d772b641352ea8e51 PCI: Fail new_id for 
vendor/device values already built into driver
7c82126a94e69bbbac586f0249e7ef11e681246c PCI: Add new ID for Intel GPU 
"spurious interrupt" quirk
473153aff4b978006f1c5fbc0e9032fd11061709 PCI: Update my email address
67ebd8140dc8923c65451fa0f6a8eee003c4dcd3 PCI: Fix incorrect vgaarb 
conditional in WARN_ON()
c1309040967e200d3ea6415ae54cf6a69d7ad996 PCI: Use designated 
initialization in PCI_VDEVICE
7ee4910ab31c4b1fafb7e4f273cbe9340ac953aa PCI: Remove old serial device IDs
56a3d18279f00c7ccbcdc193ceaf1a2f88c51457 PCI: Remove unnecessary 
includes of <linux/init.h>
ff0c41b2df1577f3354f788af4f6bb5dbdfd26da powerpc/PCI: Fix NULL 
dereference in sys_pciconfig_iobase() list traversal
c9eaa447e77efe77b7fa4c953bd62de8297fd6c5 Linux 3.15-rc1


>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>   - Fixed comments against initial version
>>   arch/arm/kernel/bios32.c |   12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
>> index 16d43cd..17a26c1 100644
>> --- a/arch/arm/kernel/bios32.c
>> +++ b/arch/arm/kernel/bios32.c
>> @@ -545,6 +545,18 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
>>   		 */
>>   		pci_bus_add_devices(bus);
>>   	}
>> +
>> +	list_for_each_entry(sys, &head, node) {
>> +		struct pci_bus *bus = sys->bus;
>> +
>> +		/* Configure PCI Express settings */
>> +		if (bus && !pci_has_flag(PCI_PROBE_ONLY)) {
>> +			struct pci_bus *child;
>> +
>> +			list_for_each_entry(child, &bus->children, node)
>> +				pcie_bus_configure_settings(child);
>> +		}
>> +	}
>>   }
>>   
>>   #ifndef CONFIG_PCI_HOST_ITE8152
>> -- 
>> 1.7.9.5
>>

