Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaJIOjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:39:15 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52802 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaJIOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:39:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Joe. C" <yingjoe.chen@mediatek.com>, arm@kernel.org,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sricharan R <r.sricharan@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, yingjoe.chen@gmail.com,
        yh.chen@mediatek.com, nathan.chung@mediatek.com,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, eddie.huang@mediatek.com,
        srv_heupstream@mediatek.com, hc.yen@mediatek.com,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] ARM: mediatek: Add sysirq interrupt polarity support
Date: Thu, 09 Oct 2014 16:37:25 +0200
Message-ID: <2076856.iIXavsNzjc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412864980-20273-5-git-send-email-yingjoe.chen@mediatek.com>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-5-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1HAiG/pA7+rfCPNPEvzge+4KGCndcDs5lKeEFVhlBIp
 vAWgNpvOymwZRVgMOPMM6Tx5p95VSptNE1nwzQkIWWVuB3qjpi
 kER1uzdimx8vw03lAjfkAsUSsv7C/vAj37OegWHpqZv93JU3sF
 tkA6oe5WG/hrQu/EOf9A3PmIwHO6HZ16Vr4K27B2dJW6RGk6cn
 MknQ7WM3aB4HUZf0Cucw7wbtYR4z2Db2cbiHhm+/rRJHG726Tl
 KzxOTIicmK4TegrRIU0leklWywUo4bvviZD5GIN7ZWm/OZbm5M
 Tg0kyH7uW+x83mBFZjz5XPMv/C95nBgEnhRSIkibJQLtcT0O1a
 scVdWm+yn06uy4mFFweg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 22:29:37 Joe. C wrote:

> +static int __init mtk_sysirq_of_init(struct device_node *node,
> +				   struct device_node *parent)
> +{
> +	struct device_node *parent_node;
> +	struct irq_domain *domain, *domain_parent = NULL;
> +	struct mt_sysirq_chip_data *chip_data;
> +	int ret = 0;
> +
> +	parent_node = of_irq_find_parent(node);
> +	if (parent_node) {
> +		domain_parent = irq_find_host(parent_node);
> +		of_node_put(parent_node);
> +	}

Just a small comment: I think the 'parent' argument to the function
already contains the device node you are looking up here, so
no need for the second variable or _find_parent call.

This means you can also drop the  = NULL assignment for the
domain.

	Arnd
