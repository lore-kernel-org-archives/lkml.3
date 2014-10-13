Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaJMOOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:14:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:57504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaJMOOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="588040190"
Message-ID: <543BDDFD.1030300@linux.intel.com>
Date: Mon, 13 Oct 2014 22:13:17 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "arm@kernel.org" <arm@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] irqdomain: Fix irq_domain_alloc_irqs return check.
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-2-git-send-email-yingjoe.chen@mediatek.com> <543BC186.2050701@arm.com>
In-Reply-To: <543BC186.2050701@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/10/13 20:11, Marc Zyngier wrote:
> On 09/10/14 15:29, Joe.C wrote:
>> From: "Joe.C" <yingjoe.chen@mediatek.com>
>>
>> Change virq type from unsigned int to int. Otherwise the return value
>> check for irq_domain_alloc_irqs will always pass.
>>
>> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
>> ---
>>  kernel/irq/irqdomain.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 584be46..dd8d3ab 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -469,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>>  	struct irq_domain *domain;
>>  	irq_hw_number_t hwirq;
>>  	unsigned int type = IRQ_TYPE_NONE;
>> -	unsigned int virq;
>> +	int virq;
>>  
>>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>>  	if (!domain) {
>>
> 
> I'd expect this patch to get folded into Jiang's series.
Hi Mark and Joe,
	Yes, my next version includes this fixup.
Regards!
Gerry
> 
> Thanks,
> 
> 	M.
> 
