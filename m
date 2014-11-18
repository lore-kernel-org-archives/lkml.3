Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaKRJ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:27:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58185 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKRJ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:27:16 -0500
Message-ID: <546B10DA.3040504@huawei.com>
Date: Tue, 18 Nov 2014 17:26:50 +0800
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
References: <20141112133941.647950773@linutronix.de> <20141112134120.393705922@linutronix.de>
In-Reply-To: <20141112134120.393705922@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Jiang,
On 2014/11/12 21:43, Thomas Gleixner wrote:

> From: Jiang Liu <jiang.liu@linux.intel.com>
[...]
> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
> +			 void *chip_data, irq_flow_handler_t handler,
> +			 void *handler_data, const char *handler_name)
> +{
> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
> +	__irq_set_handler(virq, handler, 0, handler_name);
> +	irq_set_handler_data(virq, handler_data);
> +}

When stacked domain enabled, there will be a semantic shift to the linux interrupt
identifiers. The @virq now delivers much more than before.
More specifically, now we need both @virq and @domain, rather than only @irq, to
determine which irq_data we want to configure. And once we configure @irq without
providing the exact domain, it means we are configuring all the domains related to
that @irq. So I think this routine just messed all things up.

Regards,
	Abel

