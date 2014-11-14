Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaKNBK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:10:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24155 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754AbaKNBKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:10:23 -0500
Message-ID: <54655632.2040209@huawei.com>
Date: Fri, 14 Nov 2014 09:09:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Marc Zyngier <marc.zyngier@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <54654C10.2040102@linux.intel.com>
In-Reply-To: <54654C10.2040102@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 8:25, Jiang Liu wrote:
> On 2014/11/14 5:00, Marc Zyngier wrote:
>> On 13/11/14 11:43, Jiang Liu wrote:
>>> This patch set is based on tip/irq/irqdomain and tries to refine
>>> interfaces to support irqdomain for generic MSI and PCI MSI.
>>>
>>> With this patch set applied, the generic MSI and PCI MSI interfaces
>>> are much easier to use. For extreme case, you only need to define
>>> a "struct msi_domain_info" and don't need to implement any callbacks,
>>> just using the default callbacks is OK:)
>>>
>>> This patch set is also a preparation for:
>>> 1) Kill all weak functions in drivers/pci/msi.c
>>> 2) Implement support for non-PCI-compliant MSI device
>>
>> I've rebased (once more!) the GICv3 ITS driver on top of this, and this
>> is definitely a major improvement. This is basically the first version
>> I can use without having to hack into the core code (apart from the
>> couple of nits I've mentioned earlier).
> Sorry for the rebasing, but I hope it worthy rebasing:)
> 
>>
>> Now, Thomas' idea of putting the irq_domain close to the bus is very
>> appealing, and I've tweaked an earlier patch in order to do this:
> I feel that's the right direction. There are other threads discussing
> associating an MSI controller structure with each PCI bus (at least
> root bus).
> http://www.spinics.net/lists/arm-kernel/msg376328.html

Associate the irq domain and PCI bus is not necessary, because all PCI buses under same host bridge
always share same MSI chip/irq domain, we only need associate them and pci host bridge.
I'm refactoring the pci_host_bridge, make it be a generic one, rip out of the pci root bus
creation, so we could put the irq domain and pci domain etc.. in it. Finally, we could
eliminate lots platform arch functions. I will post it out within one week.

Thanks!
Yijing.

> Regards!
> Gerry
> 
> .
> 


-- 
Thanks!
Yijing

