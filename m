Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbaFLNwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:52:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34800 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbaFLNwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:52:46 -0400
Message-ID: <5399B021.1060802@ti.com>
Date: Thu, 12 Jun 2014 19:20:25 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 15/19] irqchip: crossbar: Add kerneldoc for crossbar_domain_unmap
 callback
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-16-git-send-email-r.sricharan@ti.com> <20140612134909.GA8664@titan.lakedaemon.net>
In-Reply-To: <20140612134909.GA8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thursday 12 June 2014 07:19 PM, Jason Cooper wrote:
> On Thu, Jun 12, 2014 at 05:23:23PM +0530, Sricharan R wrote:
>> The crossbar_domain_map/unmap callbacks need not be called same number
>> of times for a particular irq. But still use counting is not needed
>> here, because unmap(irq) gets called when irq_desc(irq) is disposed.
>> After this the irq is anyways unusable and have to mapped again.
> 
> There's no need to duplicate the code comment in the commit log ;-)
Ok, will change this.
> 
>>
>> Adding the above kerneldoc for unmap callback clarity.
>>
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> ---
>>  drivers/irqchip/irq-crossbar.c |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
>> index 5f3e75a..2a73a66 100644
>> --- a/drivers/irqchip/irq-crossbar.c
>> +++ b/drivers/irqchip/irq-crossbar.c
>> @@ -101,6 +101,16 @@ static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
>>  	return 0;
>>  }
>>  
>> +/**
>> + * crossbar_domain_unmap - unmap a crossbar<->irq connection
>> + * @d: domain of irq to unmap
>> + * @irq: virq number
>> + *
>> + * The map/unmap callbacks need not be called same number of times for
> 
> s/same/the same/
ok.
> 
>> + * a particular irq. But still use counting is not needed here, because
>> + * unmap(irq) gets called when irq_desc(irq) is disposed. After this the
>> + * irq is anyways unusuable and have to be mapped again.
> 
> Please re-word this.  If I were new to the driver (I am ;-) ) I would
> have no idea what this means (and I don't :( )
> 
hmm, will reword it better then..

Regards,
 Sricharan
