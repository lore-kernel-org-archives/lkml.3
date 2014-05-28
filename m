Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaE1ROy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:14:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54591 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaE1ROv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:14:51 -0400
Message-ID: <5386195C.1080603@ti.com>
Date: Wed, 28 May 2014 13:14:04 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: pci: add call to pcie_bus_configure_settings()
References: <1401287176-4986-1-git-send-email-m-karicheri2@ti.com> <20140528165856.GA20193@obsidianresearch.com>
In-Reply-To: <20140528165856.GA20193@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/2014 12:58 PM, Jason Gunthorpe wrote:
> On Wed, May 28, 2014 at 10:26:16AM -0400, Murali Karicheri wrote:
>> PCI core supports PCIE_BUS_SAFE and PCIE_BUS_PERFORMANCE modes.
>> PCI controllers may not be able to handle pay load size higher
>> than MPS and also read data size higher than MRSS. So limit the
>> max to the least common supported payload size by calling
>> pcie_bus_configure_settings(). Using pci=pcie_bus_safe do a walk
>> and set the MPS to least common value used by devices on the bus.
>> pci=pcie_bus_perf does do a walk and set MRSS to MPS.
> This text doesn't make much sense.. Calling
> pcie_bus_configure_settings is just a good thing to do, the fact it
> helps avoid a HW defect in a specific PCI-E implementation is not the
> main reason to add this to the core ARM code.
>
>   Call pcie_bus_configure_settings on ARM, like for other
>   platforms. pcie_bus_configure_settings makes sure the MPS across the
>   bus is uniform and provides the ability to tune the MRSS and MPS to
>   higher performance values.
>
>   This is particularly important for embedded where there is no
>   firmware to program these PCI-E settings for the OS.

Thanks. I will add this text for v1.
>
>> +
>> +			list_for_each_entry(child, &bus->children, node)
>> +			pcie_bus_configure_settings(child);
>                    ^^^^^^^^^^^^^^^
>
> Missing indent.
>
> Regards,
> Jason
Will fix in v1.

Thanks
