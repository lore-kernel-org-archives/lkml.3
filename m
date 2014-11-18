Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaKRJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:25:27 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24013 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaKRJZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:25:22 -0500
Message-ID: <546B1067.2020403@huawei.com>
Date: Tue, 18 Nov 2014 17:24:55 +0800
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
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de>
In-Reply-To: <20141112134119.881823615@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Jiang,
On 2014/11/12 21:42, Thomas Gleixner wrote:

> From: Jiang Liu <jiang.liu@linux.intel.com>
> Index: tip/kernel/irq/chip.c
> ===================================================================
> --- tip.orig/kernel/irq/chip.c
> +++ tip/kernel/irq/chip.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/irqdomain.h>
>  
>  #include <trace/events/irq.h>
>  
> @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, b
>  	irq_state_clr_disabled(desc);
>  	desc->depth = 0;
>  
> +	irq_domain_activate_irq(&desc->irq_data);

I'm not sure why this is needed, please help me out.. :)

Thanks,
	Abel

>  	if (desc->irq_data.chip->irq_startup) {
>  		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
>  		irq_state_clr_masked(desc);
> @@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
>  		desc->irq_data.chip->irq_disable(&desc->irq_data);
>  	else
>  		desc->irq_data.chip->irq_mask(&desc->irq_data);
> +	irq_domain_deactivate_irq(&desc->irq_data);
>  	irq_state_set_masked(desc);
>  }
>  


