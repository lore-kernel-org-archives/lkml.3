Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbaFQRXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:23:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37735 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbaFQRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:23:38 -0400
Date: Tue, 17 Jun 2014 18:23:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "haifeng.yan@linaro.org" <haifeng.yan@linaro.org>,
        "jchxue@gmail.com" <jchxue@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH 2/2] phy: add hix5hd2-sata-phy driver
Message-ID: <20140617172302.GI8930@leverpostej>
References: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
 <1402991881-27676-3-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402991881-27676-3-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 08:58:01AM +0100, Zhangfei Gao wrote:
> From: Jiancheng Xue <xuejiancheng@huawei.com>
> 
> Add hix5hd2-sata-phy driver on Hisilicon hix5hd2 soc.
> 
> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  drivers/phy/Kconfig            |    8 ++
>  drivers/phy/Makefile           |    1 +
>  drivers/phy/phy-hix5hd2-sata.c |  192 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+)
>  create mode 100644 drivers/phy/phy-hix5hd2-sata.c
 
[...]

> +	paddr = of_get_property(phy->dev.of_node, "hisilicon,reg-init", &lenp);
> +	if (!paddr || lenp < 4 * sizeof(*paddr))
> +		return 0;
> +
> +	lenp /= sizeof(*paddr);
> +	for (i = 0; i < lenp - 3; i += 4) {
> +		offset = be32_to_cpup(paddr + i);
> +		shift = be32_to_cpup(paddr + i + 1);
> +		width = be32_to_cpup(paddr + i + 2);
> +		value = be32_to_cpup(paddr + i + 3);
> +		hix5hd2_sata_phy_write(priv->base + offset,
> +				       shift, width, value);
> +	}

There is absolutely no reason to use of_get_property and be32 values
here, we have of_property_count_u32_elems and
of_property_read_u32_index.

That said I would like to see a compelling reason for why we need to
have this at all; I'm not a fan of DT becoming a shoddy bytecode format.

Cheers,
Mark.
