Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaK2RnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:43:11 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57080 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK2RnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:43:09 -0500
Date: Sat, 29 Nov 2014 18:40:31 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        srv_heupstream@mediatek.com, devicetree@vger.kernel.org,
        hc.yen@mediatek.com, yh.chen@mediatek.com,
        linux-kernel@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, nathan.chung@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, eddie.huang@mediatek.com,
        yingjoe.chen@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 2/4] ARM: mediatek: Add sysirq interrupt polarity
 support
Message-ID: <20141129174030.GA4696@gmail.com>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
 <1416902662-19281-3-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416902662-19281-3-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:04:20PM +0800, Yingjoe Chen wrote:
> Mediatek SoCs have interrupt polarity support in sysirq which
> allows to invert polarity for given interrupt. Add this support
> using hierarchy irq domain.
>
> [...]
> 
> +static int __init mtk_sysirq_of_init(struct device_node *node,
> +				     struct device_node *parent)
> +{
> +	struct irq_domain *domain, *domain_parent;
> +	struct mtk_sysirq_chip_data *chip_data;
> +	int ret = 0;
> +
> +	domain_parent = irq_find_host(parent);
> +	if (!domain_parent) {
> +		pr_err("mtk_sysirq: interrupt-parent not found\n");
> +		return -EINVAL;
> +	}
> +
> +	chip_data = kzalloc(sizeof(*chip_data), GFP_KERNEL);
> +	if (!chip_data)
> +		return -ENOMEM;
> +
> +	chip_data->intpol_base = of_io_request_and_map(node, 0, "intpol");
> +	if (!chip_data->intpol_base) {

Hi,

you should use IS_ERR() to check the return value here.

Beniamino
