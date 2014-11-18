Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaKROYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:24:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:39344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaKROYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:24:09 -0500
Date: Tue, 18 Nov 2014 15:24:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 09/16] genirq: Add generic msi irq domain support
In-Reply-To: <546B4FC5.1050209@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181520580.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.569789374@linutronix.de> <546B3667.9040506@huawei.com> <546B4075.9050406@linux.intel.com> <546B4FC5.1050209@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
> On 2014/11/18 20:49, Jiang Liu wrote:
> >>> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
> >>> +	if (ret < 0)
> >>> +		return ret;
> >>> +
> >>> +	for (i = 0; i < nr_irqs; i++) {
> >>> +		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
> >>> +		if (ret < 0) {
> >>> +			if (ops->msi_free) {
> >>> +				for (i--; i > 0; i--)
> >>
> >> while (i--) ?

The allocation for 'i' failed. So we don't free i. You missed the real
bug here:

> >>> +				for (i--; i > 0; i--)

Must be i >= 0.

Thanks,

	tglx
