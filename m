Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaKUC7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:59:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:12554 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaKUC7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:59:04 -0500
Message-ID: <546EAA50.8000601@huawei.com>
Date: Fri, 21 Nov 2014 10:58:24 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <liviu@dudau.co.uk>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-pci@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linux-ia64@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1463511.o4kE8TX3Bd@wuerfel> <546DD688.60705@linaro.org> <20141120120850.GD9162@bart.dudau.co.uk> <546DE45C.6010306@linaro.org> <20141120163918.GE9162@bart.dudau.co.uk>
In-Reply-To: <20141120163918.GE9162@bart.dudau.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 0:39, Liviu Dudau wrote:
> On Thu, Nov 20, 2014 at 01:53:48PM +0100, Tomasz Nowicki wrote:
>> On 20.11.2014 13:08, Liviu Dudau wrote:
>>> On Thu, Nov 20, 2014 at 12:54:48PM +0100, Tomasz Nowicki wrote:
>>>> On 17.11.2014 15:13, Arnd Bergmann wrote:
>>>>> On Monday 17 November 2014 18:21:34 Yijing Wang wrote:
>>>>>> This series is based Linux 3.18-rc1 and Lorenzo Pieralisi's
>>>>>> arm PCI domain cleanup patches, link:
>>>>>> https://patchwork.ozlabs.org/patch/407585/
>>>>>>
>>>>>> Current pci scan interfaces like pci_scan_root_bus() and directly
>>>>>> call pci_create_root_bus()/pci_scan_child_bus() lack flexiblity.
>>>>>> Some platform infos like PCI domain and msi_chip have to be
>>>>>> associated to PCI bus by some arch specific function.
>>>>>> We want to make a generic pci_host_bridge, and make it hold
>>>>>> the platform infos or hook. Then we could eliminate the lots
>>>>>> of arch pci_domain_nr, also we could associate some platform
>>>>>> ops something like pci_get_msi_chip(struct pci_dev *dev)
>>>>>> with pci_host_bridge to avoid introduce arch weak functions.
>>>>>>
>>>>>> This RFC version not for all platforms, just applied the new
>>>>>> scan interface in x86/arm/powerpc/ia64, I will refresh other
>>>>>> platforms after the core pci scan interfaces are ok.
>>>>>
>>>>> I think overall this is a good direction to take, in particular
>>>>> moving more things into struct pci_host_bridge so we can
>>>>> slim down the architecture specific code.
>>>>>
>>>>> I don't particularly like the way you use the 'pci_host_info'
>>>>> to pass callback pointers and some of the generic information.
>>>>> This duplicates some of the issues we are currently trying
>>>>> to untangle in the arm32 code to make drivers easier to share
>>>>> between architectures.
>>>>>
>>>>> As a general approach, I'd rather see generic helper functions
>>>>> being exported by the PCI core that a driver may or may not
>>>>> call.
>>>>> The way you split the interface between things that happen
>>>>> before scanning the buses (pci_create_host_bridge) and
>>>>> the actual scanning (__pci_create_root_bus, pci_scan_child_bus)
>>>>> seems very helpful and I think we can expand that concept further:
>>>>>
>>>>> - The normal pci_create_host_bridge() function can contain
>>>>>   all of the DT scanning functions (finding bus/mem/io resources,
>>>>>   finding the msi-parent), while drivers that don't depend on DT
>>>>>   for this information can call the same function and fill the
>>>>>   same things after they have the pci_host_bridge pointer.
>>>>
>>>> How about finding PCI domain number (in the DT way) within
>>>> pci_create_host_bridge() too ?
>>>
>>> It is an idea worth pursuing for the 99% of the cases. I would like
>>> to understand the 1% of the time when we want a domain number to be
>>> shared between two host bridges or the time when we want more than
>>> one domain per bridge.
>> Even though we have shared domain, this should be resolved via DT calls, do
>> I miss something ?
> 
> If we only going to hold one domain number per host bridge, then no, you're
> not missing anything.
> 
>>
>>>
>>> Is that possible? Is it useful? Is it already in practice?
>> This is good question... IMO:
>> 1. Two host bridges can shared domain number if they are children of the
>> same parent host bridge.
>> 2. But I can not find good explanation for more than one domain per bridge.
> 
> Splitting a root bus into two or more "segments" ?

It seems impossible.

> 
> Best regards,
> Liviu
> 
>>
>> Tomasz
>>
>>
> 


-- 
Thanks!
Yijing

