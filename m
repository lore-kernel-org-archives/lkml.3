Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFEPt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:49:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33699 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaFEPtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:49:24 -0400
Message-ID: <5390917D.4040607@wwwdotorg.org>
Date: Thu, 05 Jun 2014 09:49:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: fwu@marvell.com, linus.walleij@linaro.org
CC: tony@atomide.com, plagnioj@jcrosoft.com, kgene.kim@samsung.com,
        heiko@sntech.de, t.figa@samsung.com, thomas.abraham@linaro.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, thierry.reding@gmail.com, baohua@kernel.org,
        viresh.linux@gmail.com, matt.porter@linaro.org, syin@broadcom.com,
        jg1.han@samsung.com, Rongjun.Ying@csr.com, Rong.Wang@csr.com,
        linux@prisktech.co.nz, yongjun_wei@trendmicro.com.cn,
        laurent.navet@gmail.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, cxie4@marvell.com, ylmao@marvell.com,
        njiang1@marvell.com, tianxf@marvell.com, fswu@marvell.com
Subject: Re: [PATCH v5] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401951040-17403-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1401951040-17403-1-git-send-email-fwu@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 12:50 AM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
> 
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>   calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> 3.Remove the disable ops in struct pinmux_ops
> 4.Remove all the disable ops users in current code base.
...

The overall concept, plus the bcm2835, and Tegra driver parts,
Acked-by: Stephen Warren <swarren@nvidia.com>

That said ...

> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c

> -static void tegra_pinctrl_disable(struct pinctrl_dev *pctldev,
> -				  unsigned function, unsigned group)
> -{
> -	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> -	const struct tegra_pingroup *g;
> -	u32 val;
> -
> -	g = &pmx->soc->groups[group];
> -
> -	if (WARN_ON(g->mux_reg < 0))
> -		return;
> -
> -	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
> -	val &= ~(0x3 << g->mux_bit);
> -	val |= g->func_safe << g->mux_bit;
> -	pmx_writel(pmx, val, g->mux_bank, g->mux_reg);

Those last 5 lines don't exist in the latest code, so this patch won't
apply cleanly. You probably want to rebase this on top of LinusW's
latest pinctrl development branch.
