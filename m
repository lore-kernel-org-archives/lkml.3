Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaKMKAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:00:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:10228 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbaKMKAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:00:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="636282759"
Message-ID: <54648138.2070900@linux.intel.com>
Date: Thu, 13 Nov 2014 18:00:24 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
References: <20141112133941.647950773@linutronix.de>	 <20141112134120.393705922@linutronix.de> <1415872649.17958.37.camel@mtksdaap41>
In-Reply-To: <1415872649.17958.37.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 17:57, Yingjoe Chen wrote:
> On Wed, 2014-11-12 at 13:43 +0000, Thomas Gleixner wrote:
>> Index: tip/kernel/irq/irqdomain.c
>> ===================================================================
>> --- tip.orig/kernel/irq/irqdomain.c
>> +++ tip/kernel/irq/irqdomain.c
>> @@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct
>>  	return 0;
>>  }
>>  
>> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
>> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
>> +			 void *chip_data, irq_flow_handler_t handler,
>> +			 void *handler_data, const char *handler_name)
>> +{
>> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
>> +	__irq_set_handler(virq, handler, 0, handler_name);
>> +	irq_set_handler_data(virq, handler_data);
>> +}
>> +
> 
> Hi,
> 
> While trying to use this function, I'm not sure about its interface.
> This function have 8 parameters but only save 3 function calls. After
> checking uses in Jiang's original patch, I think this make code harder
> to understand.
Hi Joe,
	It's true, but we also want to reduce duplicated code:(
Regards!
Gerry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
