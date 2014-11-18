Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaKROPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:15:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:26244 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaKROPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:15:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609790512"
Message-ID: <546B5469.5020402@linux.intel.com>
Date: Tue, 18 Nov 2014 22:15:05 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com>
In-Reply-To: <546B51BA.6070806@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/11/18 22:03, Jiang Liu wrote:
> On 2014/11/18 21:52, Yun Wu (Abel) wrote:
>> On 2014/11/18 21:43, Jiang Liu wrote:
>>
>>> On 2014/11/18 21:33, Yun Wu (Abel) wrote:
>>> Hi Yun,
>>> 	We provide an irq_chip for each type of interrupt controller
>>> instead of devices. For the example mentioned above, if device A
>>> and Group B has different interrupt controllers, we just need to
>>> implement irq_chip_A and irq_chip_B and set irq_chip.irq_write_msi_msg()
>>> to suitable callbacks.
>>> 	The framework already achieves what you you want:)
>>
>> What if device A and group B have the same interrupt controller?
> Device doesn't care about interrupt controllers, it just cares about
> interrupts used by itself. It's the interrupt source (controller)
> enumerators' responsibility to discover interrupt source, associate
> methods to control the interrupt source and assign irq numbers for
> interrupt sources.
> There are two ways to associate irq numbers with device:
> 1) arch code/bus drivers statically assigns irq number for devices
>    when creating device objects, such as PCI legacy interrupt
>    (INTA-INTD), IOAPIC interrupts.
> 2) device drivers ask interrupt source enumerators to dynamically
>    create irq numbers, such pci_enable_msix_range() and friends.
> So device driver definitely doesn't need to known about irq_chip
> methods to control interrupt sources.
Please refer to
http://www.xisanqi.net/year/2014/pdf/2014-pdf-09-reconstruct-x86-interrupt-architecture.pdf
for more information
about the hierarchy irqdomain background:)

> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
