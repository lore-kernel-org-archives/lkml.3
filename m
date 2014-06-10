Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaFJRcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:32:45 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33204 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaFJRcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <539716F7.1020901@ti.com>
References: <1401297293-3950-1-git-send-email-m-karicheri2@ti.com>
 <20140530154455.GC4607@google.com> <539716F7.1020901@ti.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Jun 2014 11:32:22 -0600
Message-ID: <CAErSpo58cvbmyD90rNB9RHRHjGoehbGcHa8F3i82yMiQXPBNVw@mail.gmail.com>
Subject: Re: [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 8:32 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 5/30/2014 11:44 AM, Bjorn Helgaas wrote:
>>
>> On Wed, May 28, 2014 at 01:14:53PM -0400, Murali Karicheri wrote:
>>>
>>> Call pcie_bus_configure_settings on ARM, like for other platforms.
>>> pcie_bus_configure_settings makes sure the MPS across the bus is
>>> uniform and provides the ability to tune the MRSS and MPS to higher
>>> performance values. This is particularly important for embedded where
>>> there is no firmware to program these PCI-E settings for the OS.
>>>
>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>
>> I applied this to pci/misc for v3.16.  Russell, let me know if you object
>> or prefer another route, and I can drop it.  I tweaked the changelog but
>> didn't touch the actual patch, so I think git will do the right thing if
>> it
>> arrives via two trees.
>
> Bjorn,
>
> I checked git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
> pci/misc branch
> I don't see it. Is it a different repo?

It's already in Linus' tree and I cleaned out pci/misc for the next cycle.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8b5742ad156d30ee38486652cdbd152e2d6ebbcc

>>> CC: Russell King <linux@arm.linux.org.uk>
>>> CC: Bjorn Helgaas <bhelgaas@google.com>
>>> CC: Arnd Bergmann <arnd@arndb.de>
>>> CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>>>   - Fixed comments against initial version
>>>   arch/arm/kernel/bios32.c |   12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
>>> index 16d43cd..17a26c1 100644
>>> --- a/arch/arm/kernel/bios32.c
>>> +++ b/arch/arm/kernel/bios32.c
>>> @@ -545,6 +545,18 @@ void pci_common_init_dev(struct device *parent,
>>> struct hw_pci *hw)
>>>                  */
>>>                 pci_bus_add_devices(bus);
>>>         }
>>> +
>>> +       list_for_each_entry(sys, &head, node) {
>>> +               struct pci_bus *bus = sys->bus;
>>> +
>>> +               /* Configure PCI Express settings */
>>> +               if (bus && !pci_has_flag(PCI_PROBE_ONLY)) {
>>> +                       struct pci_bus *child;
>>> +
>>> +                       list_for_each_entry(child, &bus->children, node)
>>> +                               pcie_bus_configure_settings(child);
>>> +               }
>>> +       }
>>>   }
>>>     #ifndef CONFIG_PCI_HOST_ITE8152
>>> --
>>> 1.7.9.5
>>>
>
