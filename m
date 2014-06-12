Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaFLNhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:37:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaFLNhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:37:46 -0400
Message-ID: <5399AC9C.4080602@ti.com>
Date: Thu, 12 Jun 2014 19:05:24 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-9-git-send-email-r.sricharan@ti.com> <20140612131042.GU8664@titan.lakedaemon.net>
In-Reply-To: <20140612131042.GU8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thursday 12 June 2014 06:40 PM, Jason Cooper wrote:
> On Thu, Jun 12, 2014 at 05:23:16PM +0530, Sricharan R wrote:
>> From: Nishanth Menon <nm@ti.com>
>>
>> remove un-necessary space in function pointer.
>>
>> Fixes checkpatch warning:
>> WARNING: Unnecessary space before function pointer arguments
>>  #37: FILE: drivers/irqchip/irq-crossbar.c:37:
>>  +	void (*write) (int, int);
>>
>> WARNING: Missing a blank line after declarations
>> +	int *register_offsets;
>> +	void (*write)(int, int);
>>
>> WARNING: Prefer kcalloc over kzalloc with multiply
>> +	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
>>
>> WARNING: Prefer kcalloc over kzalloc with multiply
>> +	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>  drivers/irqchip/irq-crossbar.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
>> index 5da9d36..58790d4 100644
>> --- a/drivers/irqchip/irq-crossbar.c
>> +++ b/drivers/irqchip/irq-crossbar.c
>> @@ -34,7 +34,8 @@ struct crossbar_device {
>>  	uint *irq_map;
>>  	void __iomem *crossbar_base;
>>  	int *register_offsets;
>> -	void (*write) (int, int);
>> +
>> +	void (*write)(int, int);
> 
> The empty line here looks bogus to me.  Did you re-run checkpatch after
> fixing the unnecessary space to see if it still complained about having
> a 'blank line after declarations'?
> 
 Yes, it still complains even after fixing unnecessary space.

WARNING: Missing a blank line after declarations
#37: FILE: ./drivers/irqchip/irq-crossbar.c:37:
+	int *register_offsets;
+	void (*write)(int, int);

>>  };
>>  
>>  /**
>> @@ -150,7 +151,7 @@ static int __init crossbar_of_init(struct device_node *node,
>>  		goto err1;
>>  
>>  	of_property_read_u32(node, "ti,max-irqs", &max);
>> -	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
>> +	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
>>  	if (!cb->irq_map)
>>  		goto err2;
>>  
>> @@ -176,7 +177,7 @@ static int __init crossbar_of_init(struct device_node *node,
>>  		}
>>  	}
>>  
>> -	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
>> +	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
>>  	if (!cb->register_offsets)
>>  		goto err3;
> 
> I'm generally opposed to these sorts of checkpatch patches, especially
> when they are just warnings.  It's great for a new driver in the staging
> tree, but it makes backporting future bugfixes that much harder when
> drivers have been live in mainline.
> 
> If, in the future, you're changing code in this area, go ahead and
> convert to kcalloc(), but I wouldn't do a separate patch for this kind
> of thing.
> 
> Honestly, I would just drop this patch and not worry about it.
> 
  Ok, but i just hope that there may not be real needs to make changes
  for this driver in future. So if that's the case then it might be 
  better to fix it once for now.

Regards,
 Sricharan
