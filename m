Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaKRMin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:38:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:24856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaKRMim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:38:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="638933045"
Message-ID: <546B3DCD.9090307@linux.intel.com>
Date: Tue, 18 Nov 2014 20:38:37 +0800
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
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
References: <20141112133941.647950773@linutronix.de> <20141112134120.393705922@linutronix.de> <546B10DA.3040504@huawei.com> <alpine.DEB.2.11.1411181102160.3909@nanos> <546B31D7.6030204@huawei.com>
In-Reply-To: <546B31D7.6030204@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 19:47, Yun Wu (Abel) wrote:
> On 2014/11/18 18:03, Thomas Gleixner wrote:
> 
>> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>>
>>> Hi Thomas, Jiang,
>>> On 2014/11/12 21:43, Thomas Gleixner wrote:
>>>
>>>> From: Jiang Liu <jiang.liu@linux.intel.com>
>>> [...]
>>>> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>>>> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
>>>> +			 void *chip_data, irq_flow_handler_t handler,
>>>> +			 void *handler_data, const char *handler_name)
>>>> +{
>>>> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
>>>> +	__irq_set_handler(virq, handler, 0, handler_name);
>>>> +	irq_set_handler_data(virq, handler_data);
>>>> +}
>>>
>>> When stacked domain enabled, there will be a semantic shift to the linux interrupt
>>> identifiers. The @virq now delivers much more than before.
>>> More specifically, now we need both @virq and @domain, rather than only @irq, to
>>> determine which irq_data we want to configure. And once we configure @irq without
>>> providing the exact domain, it means we are configuring all the domains related to
>>> that @irq. So I think this routine just messed all things up.
>>
>> You can mess up anything by using an interface in the wrong way. Open
>> coding will not make that harder.
>>
> 
> But what's the correct way to use this interface?
Hi Yun,
	It's to be used by interrupt controller drivers to implement
hierarchy irqdomains.
Regards!
Gerry

> 
> Thanks,
> 	Abel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
