Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaLAOJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:09:38 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54752 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752404AbaLAOJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:09:37 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v8 2/4] ARM: mediatek: Add sysirq interrupt polarity
 support
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Beniamino Galvani <b.galvani@gmail.com>
CC: Mark Rutland <mark.rutland@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>,
        <hc.yen@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, <eddie.huang@mediatek.com>,
        <yingjoe.chen@gmail.com>, <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20141129174030.GA4696@gmail.com>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416902662-19281-3-git-send-email-yingjoe.chen@mediatek.com>
	 <20141129174030.GA4696@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 1 Dec 2014 22:09:33 +0800
Message-ID: <1417442973.24330.6.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-29 at 18:40 +0100, Beniamino Galvani wrote:
> On Tue, Nov 25, 2014 at 04:04:20PM +0800, Yingjoe Chen wrote:
> > Mediatek SoCs have interrupt polarity support in sysirq which
> > allows to invert polarity for given interrupt. Add this support
> > using hierarchy irq domain.
> >
> > [...]
> > 
> > +static int __init mtk_sysirq_of_init(struct device_node *node,
> > +				     struct device_node *parent)
> > +{
> > +	struct irq_domain *domain, *domain_parent;
> > +	struct mtk_sysirq_chip_data *chip_data;
> > +	int ret = 0;
> > +
> > +	domain_parent = irq_find_host(parent);
> > +	if (!domain_parent) {
> > +		pr_err("mtk_sysirq: interrupt-parent not found\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
> > +	if (!chip_data)
> > +		return -ENOMEM;
> > +
> > +	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
> > +	if (!chip_data->intpol_base) {
> 
> Hi,
> 
> you should use IS_ERR() to check the return value here.

Thanks for catching this. I think this is merged, so I'll prepare a new
patch to fix this.

Joe.C


