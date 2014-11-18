Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaKRKDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:03:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:37847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKRKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:03:34 -0500
Date: Tue, 18 Nov 2014 11:03:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info() to
 reduce duplicated code
In-Reply-To: <546B10DA.3040504@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181102160.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.393705922@linutronix.de> <546B10DA.3040504@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:

> Hi Thomas, Jiang,
> On 2014/11/12 21:43, Thomas Gleixner wrote:
> 
> > From: Jiang Liu <jiang.liu@linux.intel.com>
> [...]
> > +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
> > +			 irq_hw_number_t hwirq, struct irq_chip *chip,
> > +			 void *chip_data, irq_flow_handler_t handler,
> > +			 void *handler_data, const char *handler_name)
> > +{
> > +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
> > +	__irq_set_handler(virq, handler, 0, handler_name);
> > +	irq_set_handler_data(virq, handler_data);
> > +}
> 
> When stacked domain enabled, there will be a semantic shift to the linux interrupt
> identifiers. The @virq now delivers much more than before.
> More specifically, now we need both @virq and @domain, rather than only @irq, to
> determine which irq_data we want to configure. And once we configure @irq without
> providing the exact domain, it means we are configuring all the domains related to
> that @irq. So I think this routine just messed all things up.

You can mess up anything by using an interface in the wrong way. Open
coding will not make that harder.

Thanks,

	tglx
