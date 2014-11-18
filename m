Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaKRLsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:48:54 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:22124 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaKRLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:48:53 -0500
Message-ID: <546B320A.4060202@huawei.com>
Date: Tue, 18 Nov 2014 19:48:26 +0800
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
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <546B1067.2020403@huawei.com> <alpine.DEB.2.11.1411181048110.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181048110.3909@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.546B3216.00D3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7e1ae2310568d419ea66557ddbfd4639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 17:54, Thomas Gleixner wrote:

> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>> Hi Thomas, Jiang,
>> On 2014/11/12 21:42, Thomas Gleixner wrote:
>>
>>> From: Jiang Liu <jiang.liu@linux.intel.com>
>>> Index: tip/kernel/irq/chip.c
>>> ===================================================================
>>> --- tip.orig/kernel/irq/chip.c
>>> +++ tip/kernel/irq/chip.c
>>> @@ -15,6 +15,7 @@
>>>  #include <linux/module.h>
>>>  #include <linux/interrupt.h>
>>>  #include <linux/kernel_stat.h>
>>> +#include <linux/irqdomain.h>
>>>  
>>>  #include <trace/events/irq.h>
>>>  
>>> @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, b
>>>  	irq_state_clr_disabled(desc);
>>>  	desc->depth = 0;
>>>  
>>> +	irq_domain_activate_irq(&desc->irq_data);
>>
>> I'm not sure why this is needed, please help me out.. :)
> 
> Because it makes the whole error handling in stacked allocations way
> simpler.
> 
> We allocate and reserve resources, but do not program the hardware up
> to the point where request_irq and therefor irq_startup() is invoked.
> 
> So when in the allocation/reservation phase any of the stack level
> fails we just have to undo the allocations/reservations and not any
> hardware settings.
> 
> That also solves the issue that depending on the stacking we might not
> be able to program the hardware during the allocation because all
> stack levels need to be allocated/reserved before we can figure out
> which hardware configuration we need for the various levels.
> 
> So we decided to postpone the actual hardware programming to the point
> where the interrupt actually gets used.
> 

OK, I got it.

Thanks,
	Abel

