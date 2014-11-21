Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbaKUMMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:12:48 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48498 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966AbaKUMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:12:47 -0500
Message-ID: <546F2A65.30002@gmail.com>
Date: Fri, 21 Nov 2014 20:04:53 +0800
From: Yijing Wang <wangyijing0307@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yijing Wang <wangyijing@huawei.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com> <alpine.DEB.2.11.1411210233250.6439@nanos> <546F140B.1050607@arm.com>
In-Reply-To: <546F140B.1050607@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014/11/21 18:29, Marc Zyngier 写道:
> Hi Thomas,
>
> On 21/11/14 01:46, Thomas Gleixner wrote:
>> On Fri, 21 Nov 2014, Yijing Wang wrote:
>>> On 2014/11/21 0:31, Marc Zyngier wrote:
>>>> Bjorn, Yijing,
>>>>
>>>> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
>>>> bus->msi assignment) completely breaks MSI on arm64 when using the new
>>>> MSI stacked domain:
>>> Sorry, this is my first part to refactor MSI related code, now how
>>> to get pci msi_controller depends arch
>>> functions(pcibios_msi_controller() or arch_setup_msi_irq()), we are
>>> working on generic pci_host_bridge, after that, we could eventually
>>> eliminate MSI arch functions and find pci dev 's msi controller by
>>> pci_host_bridge->get_msi_controller().
>> The main question is why you think that pci_host_bridge is the proper
>> place to store that information.
>>
>> On x86 we have DMAR units associated to a single device. Each DMAR
>> unit is a seperate MSI irq domain.
>>
>> Can you guarantee that the pci_host_bridge is the right point to
>> provide the association of the device to the irq domain?
>>
>> So the real question is:
>>
>>     What is the association level requirement to properly identify the
>>     irqdomain for a specific device on any given architecture with and
>>     without IOMMU, interrupt redirection etc.
>>
>> To be honest: I don't know.
>>
>> My gut feeling tells me that it's at the device level, but I really
>> leave that decision to the experts in that field.
> Given the above requirement (single device associated to DMAR), I can
> see two possibilities:
> - we represent DMAR as a single PCI bus: feels a bit artificial
> - we move the MSI domain to the device, as you suggested.
>
> The second one seems a lot more attractive to me. What I don't
> completely see is how the host bridge has all required the knowledge.

Hmmm, maybe I'm in the wrong direction,  I need to think more about it.

Thanks!
Yijing.


>
> Also, it is not clear to me what is the advantage of getting rid of the
> MSI controller. By doing so, we loose an important part of the topology
> information (the irq domain is another level of abstraction).
>
> Thanks,
>
> 	M.

