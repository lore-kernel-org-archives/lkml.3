Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaFWHXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:23:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42965 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaFWHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:23:12 -0400
Message-ID: <53A7D541.6090009@ti.com>
Date: Mon, 23 Jun 2014 12:50:33 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <tglx@linutronix.de>,
        <joe@perches.com>
Subject: Re: [PATCH V3 03/16] irqchip: crossbar: introduce ti,irqs-skip to
 skip
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com> <1402917796-31574-4-git-send-email-r.sricharan@ti.com> <20140621023302.GE21711@titan.lakedaemon.net>
In-Reply-To: <20140621023302.GE21711@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2014 08:03 AM, Jason Cooper wrote:
> Sricharan,
> 
> Your subject line seems truncated:
> 
>   "irqchip: crossbar: introduce ti,irqs-skip to skip"
> 
> maybe "... Introduce DT property to skip hardwired irqs" ?
> 
> Also note that you need to correct the subject line for *every* patch in
> the series wrt capitalization.
> 
> I don't mind correcting it when I apply it, provided that:
> 
ha, i think this got truncated unintentionally. Sorry will fix this.
>  - the patch is otherwise ready
>  - I only have to do it once or twice for the series
>  - I never had a chance to ask since you created a rockstar patch series
>    the first time out of the gate (except for capitalization).
> 
> Once I've looked over the whole series, please resend with the subject
> lines corrected.
> 
Ok. I will look for your comments on the rest of the patches and
resend with capitalization fix said above.

> On Mon, Jun 16, 2014 at 04:53:03PM +0530, Sricharan R wrote:
>> From: Nishanth Menon <nm@ti.com>
>>
>> When, in the system due to varied reasons, interrupts might be unusable
>> due to hardware behavior, but register maps do exist, then those interrupts
>> should be skipped while mapping irq to crossbars.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> ---
>> [V3] introduced ti,irqs-skip dt property to list the
>>      irqs to be skipped.
>>
>>  .../devicetree/bindings/arm/omap/crossbar.txt      |    4 ++++
>>  drivers/irqchip/irq-crossbar.c                     |   20 ++++++++++++++++++++
>>  2 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>> index fb88585..cfcbd52 100644
>> --- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>> +++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
>> @@ -17,6 +17,10 @@ Required properties:
>>  		 so crossbar bar driver should not consider them as free
>>  		 lines.
>>  
>> +Optional properties:
>> +- ti,irqs-skip: This is similar to "ti,irqs-reserved", but are irq mappings
>> +  which are not supposed to be used for errata or other reasons(virtualization).
> 
> I would specifically mention SoC-specific hard-wiring of irqs here.
> Also the fact that the hardwiring unexpectedly bypasses the crossbar.
ok, that will be more easily understandable and will add that.
> 
>> +
>>  Examples:
>>  		crossbar_mpu: @4a020000 {
>>  			compatible = "ti,irq-crossbar";
> 
> Please include a ti,irqs-skip example here.
> 
ok.
>> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
>> index 51d4b87..27049de 100644
>> --- a/drivers/irqchip/irq-crossbar.c
>> +++ b/drivers/irqchip/irq-crossbar.c
>> @@ -18,6 +18,7 @@
>>  
>>  #define IRQ_FREE	-1
>>  #define IRQ_RESERVED	-2
>> +#define IRQ_SKIP	-3
>>  #define GIC_IRQ_START	32
>>  
>>  /*
>> @@ -160,6 +161,25 @@ static int __init crossbar_of_init(struct device_node *node)
>>  		}
>>  	}
>>  
>> +	/* Skip the ones marked as skip */
> 
> This comment is redundant, perhaps "Skip irqs hardwired to bypass the
> crossbar."?
ok, will change this.

Regards,
 Sricharan
