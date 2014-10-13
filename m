Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaJMML5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:11:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40127 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaJMML4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:11:56 -0400
Message-ID: <543BC186.2050701@arm.com>
Date: Mon, 13 Oct 2014 13:11:50 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Joe.C" <yingjoe.chen@mediatek.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
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
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-2-git-send-email-yingjoe.chen@mediatek.com>
In-Reply-To: <1412864980-20273-2-git-send-email-yingjoe.chen@mediatek.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Oct 2014 12:11:51.0687 (UTC) FILETIME=[DF153170:01CFE6DE]
X-MC-Unique: 114101313115404101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 15:29, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Change virq type from unsigned int to int. Otherwise the return value
> check for irq_domain_alloc_irqs will always pass.
> 
> Signed-off-by: Joe.C <yingjoe.chen@mediatek.com>
> ---
>  kernel/irq/irqdomain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 584be46..dd8d3ab 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -469,7 +469,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
>  	struct irq_domain *domain;
>  	irq_hw_number_t hwirq;
>  	unsigned int type = IRQ_TYPE_NONE;
> -	unsigned int virq;
> +	int virq;
>  
>  	domain = irq_data->np ? irq_find_host(irq_data->np) : irq_default_domain;
>  	if (!domain) {
> 

I'd expect this patch to get folded into Jiang's series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

