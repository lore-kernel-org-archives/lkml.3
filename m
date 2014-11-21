Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaKUCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:09:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:3679 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320AbaKUCJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:09:58 -0500
Message-ID: <546E9DF0.5010002@huawei.com>
Date: Fri, 21 Nov 2014 10:05:36 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com> <alpine.DEB.2.11.1411210233250.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411210233250.6439@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 9:46, Thomas Gleixner wrote:
> On Fri, 21 Nov 2014, Yijing Wang wrote:
>> On 2014/11/21 0:31, Marc Zyngier wrote:
>>> Bjorn, Yijing,
>>>
>>> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
>>> bus->msi assignment) completely breaks MSI on arm64 when using the new
>>> MSI stacked domain:
>>
>> Sorry, this is my first part to refactor MSI related code, now how
>> to get pci msi_controller depends arch
>> functions(pcibios_msi_controller() or arch_setup_msi_irq()), we are
>> working on generic pci_host_bridge, after that, we could eventually
>> eliminate MSI arch functions and find pci dev 's msi controller by
>> pci_host_bridge->get_msi_controller().
> 
> The main question is why you think that pci_host_bridge is the proper
> place to store that information.
> 
> On x86 we have DMAR units associated to a single device. Each DMAR
> unit is a seperate MSI irq domain. 
> 
> Can you guarantee that the pci_host_bridge is the right point to
> provide the association of the device to the irq domain?
> 
> So the real question is:
> 
>    What is the association level requirement to properly identify the
>    irqdomain for a specific device on any given architecture with and
>    without IOMMU, interrupt redirection etc.
> 
> To be honest: I don't know.
> 
> My gut feeling tells me that it's at the device level, but I really
> leave that decision to the experts in that field.

I choose the pci_host_bridge to place the .get_msi_ctrl() ops, because
I think how to associate pci_dev and msi_controller is platform specific,
and we could initialize pci_host_bridge in platform pci host drivers to
avoid call platform specific functions when we scan or setup a pci device.

Thanks!
Yijing.

> 
> Thanks,
> 
> 	tglx
> 
> .
> 


-- 
Thanks!
Yijing

