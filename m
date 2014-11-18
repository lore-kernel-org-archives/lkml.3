Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbaKROwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:52:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:6439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaKROwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:52:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488413187"
Message-ID: <546B5D2B.7000206@linux.intel.com>
Date: Tue, 18 Nov 2014 22:52:27 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <alpine.DEB.2.11.1411181518310.3909@nanos> <546B5904.6020200@huawei.com>
In-Reply-To: <546B5904.6020200@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 22:34, Yun Wu (Abel) wrote:
> On 2014/11/18 22:19, Thomas Gleixner wrote:
> 
>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>> On 2014/11/18 21:43, Jiang Liu wrote:
>>>> 	We provide an irq_chip for each type of interrupt controller
>>>> instead of devices. For the example mentioned above, if device A
>>>> and Group B has different interrupt controllers, we just need to
>>>> implement irq_chip_A and irq_chip_B and set irq_chip.irq_write_msi_msg()
>>>> to suitable callbacks.
>>>> 	The framework already achieves what you you want:)
>>>
>>> What if device A and group B have the same interrupt controller?
>>
>> Well, if write_msg() is different they are hardly the same.
>>
> 
> The GICv3 ITS now deals with both PCI and non PCI message interrupts.
> We can't require the new devices behave writing message in a same way.
> What we can do is to abstract all the endpoints' behavior, and I
> provided one abstraction in an earlier reply.
It should be easy to extend:)
Actually, x86 interrupt remapping drivers already support two types of
MSIs, one is PCI MSI/MSIX, another is HPET interrupt.
> 
> Thanks,
> 	Abel
> 
