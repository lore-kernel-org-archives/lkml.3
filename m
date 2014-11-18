Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaKRLsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:48:36 -0500
Received: from [119.145.14.65] ([119.145.14.65]:58139 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaKRLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:48:35 -0500
Message-ID: <546B31D7.6030204@huawei.com>
Date: Tue, 18 Nov 2014 19:47:35 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
References: <20141112133941.647950773@linutronix.de> <20141112134120.393705922@linutronix.de> <546B10DA.3040504@huawei.com> <alpine.DEB.2.11.1411181102160.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181102160.3909@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 18:03, Thomas Gleixner wrote:

> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
> 
>> Hi Thomas, Jiang,
>> On 2014/11/12 21:43, Thomas Gleixner wrote:
>>
>>> From: Jiang Liu <jiang.liu@linux.intel.com>
>> [...]
>>> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>>> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
>>> +			 void *chip_data, irq_flow_handler_t handler,
>>> +			 void *handler_data, const char *handler_name)
>>> +{
>>> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
>>> +	__irq_set_handler(virq, handler, 0, handler_name);
>>> +	irq_set_handler_data(virq, handler_data);
>>> +}
>>
>> When stacked domain enabled, there will be a semantic shift to the linux interrupt
>> identifiers. The @virq now delivers much more than before.
>> More specifically, now we need both @virq and @domain, rather than only @irq, to
>> determine which irq_data we want to configure. And once we configure @irq without
>> providing the exact domain, it means we are configuring all the domains related to
>> that @irq. So I think this routine just messed all things up.
> 
> You can mess up anything by using an interface in the wrong way. Open
> coding will not make that harder.
> 

But what's the correct way to use this interface?

Thanks,
	Abel

