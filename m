Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3LIL1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:27:34 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:44988 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760298Ab3LIL1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:27:31 -0500
Message-ID: <52A5A7B2.4000509@st.com>
Date: Mon, 9 Dec 2013 11:21:22 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, <netdev@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC
 in Allwinner A20 SoC's
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-5-git-send-email-wens@csie.org>
In-Reply-To: <1386350983-13281-5-git-send-email-wens@csie.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/13 17:29, Chen-Yu Tsai wrote:
> +static int sun7i_gmac_init(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct device *dev = &pdev->dev;
> +	void __iomem *addr = NULL;
> +	struct plat_stmmacenet_data *plat_dat = NULL;
> +	u32 priv_clk_reg;
> +
> +	plat_dat = dev_get_platdata(&pdev->dev);
> +	if (!plat_dat)
> +		return -EINVAL;
dev_get_platdata will return NULL for DT, So this function will fail all
the time.

How is it supposed to work?
Am I missing some thing?

--srini
> +
> +	/* Get GMAC clock register in CCU */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	addr = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(addr))

