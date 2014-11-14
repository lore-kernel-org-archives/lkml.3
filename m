Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaKNOLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:11:50 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47270 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbaKNOLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:11:48 -0500
Message-ID: <54660D7F.70702@gmail.com>
Date: Fri, 14 Nov 2014 22:11:11 +0800
From: Yijing Wang <wangyijing0307@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yijing Wang <wangyijing@huawei.com>
CC: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <54654C10.2040102@linux.intel.com> <54655632.2040209@huawei.com> <alpine.DEB.2.11.1411140211480.3935@nanos> <54655D44.1070703@linux.intel.com>
In-Reply-To: <54655D44.1070703@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014/11/14 9:39, Jiang Liu 写道:
> On 2014/11/14 9:31, Thomas Gleixner wrote:
>> On Fri, 14 Nov 2014, Yijing Wang wrote:
>>
>> Could you please use a mail client which does proper line wraps or
>> configure yours to do so?
>>
>>> Associate the irq domain and PCI bus is not necessary, because all
>>> PCI buses under same host bridge always share same MSI chip/irq
>>> domain, we only need associate them and pci host bridge.
>>>
>>> I'm refactoring the pci_host_bridge, make it be a generic one, rip
>>> out of the pci root bus creation, so we could put the irq domain and
>>> pci domain etc.. in it. Finally, we could eliminate lots platform
>>> arch functions. I will post it out within one week.
>> That's a completely orthogonal problem. From the MSI/interrupt
>> handling POV it does not matter at all where that information is
>> stored. All we care about is that it is retrievable via the (pci)
>> device which tries to setup MSI[X].
>>
>> So we can store/retrieve it via generic functions into/from whatever
>> is available right now. If the irq side has generic interfaces to do
>> so then this wont conflict with your decisions to change the final
>> storage point because all it takes is to tweak the storage/retrieve
>> functions.
>>
>> So all we need at the moment is an agreed on way to store/retrieve
>> that information which is based on the current shared infrastructure,
>> aka. Linus tree. If we can utilize that you are completely free to
>> change the association mechanism underneath.
> Hi Thomas,
> 	So we need something like:
> struct msi_chip *pci_get_msi_chip(struct pci_dev *);
> or:
> struct irq_domain *pci_get_msi_domain(struct pci_dev *);

Hi Gerry,
what about associate the platform specific  struct msi_chip 
*pci_get_msi_chip(struct pci_dev *)
with struct pci_host_bridge. we could provide the private 
"pci_get_msi_chip()" in the PCI
host drivers.

Thanks!
Yijing.

>
> BTW, there's a conflict when merging tip/irq/irqdomain into
> tip/x86/apic. It's my first time to deal with merging conflicts,
> what's the preferred way? Is it working like this?
> 1) I merge the two branch
> 2) I rebase my x86 irqdomain patch sets and send them to you
> 3) You merge the two branch and apply my patch set.
> Regards!
> Gerry
>> Thanks,
>>
>> 	tglx
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

