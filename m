Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaKMNGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:06:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:33104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaKMNGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:06:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487167686"
Message-ID: <5464ACAF.9060809@linux.intel.com>
Date: Thu, 13 Nov 2014 21:05:51 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <5464A3F8.1000807@huawei.com> <5464A68E.4010004@linux.intel.com> <5464AA4A.6020508@huawei.com>
In-Reply-To: <5464AA4A.6020508@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 20:55, Yijing Wang wrote:
> On 2014/11/13 20:39, Jiang Liu wrote:
>>
>>
>> On 2014/11/13 20:28, Yijing Wang wrote:
>>> On 2014/11/13 19:43, Jiang Liu wrote:
>>>> This patch set is based on tip/irq/irqdomain and tries to refine
>>>> interfaces to support irqdomain for generic MSI and PCI MSI.
>>>>
>>>> Patch 1 is just minor fixes for tip/irq/irqdomain.
>>>>
>>>> Patch 2 introduces some helpers to hide struct msi_desc implementation
>>>> details, so later we could move msi_list from struct pci_dev into
>>>> struct device to enable generic MSI support.
>>>
>>> Hi Gerry,
>>>    I tried to move msi info(eg. msi_list) into struct device, but I found
>>> DMAR fault interrupt is initialized before the driver core init. And I don't
>>> know whether there are other devices like ARM consolidator(introduced in GIC v3)
>>> need to be initialized before driver core. What do you think about this ?
>> Hi Yijing,
>> 	DMAR interrupt doesn't make use of msi_desc, so has no
>> dependency on msi_list.
> 
> OK, I thought we could use msi_desc to describe DMAR/HPET irq, so they could
> share the mask/unmask, write_msg/read_etc.. But maybe it's not a right direction. :)
And DMAR/HPET interrupts are not associated with any struct device
object, no way to build msi_desc list at all:)
