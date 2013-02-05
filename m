Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3BEKiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:38:54 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42148 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BEKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:38:51 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-9e-5110e1393287
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
Date: Tue, 05 Feb 2013 11:38:46 +0100
Message-id: <1554530.H35cUWvpSY@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.5 (Linux/3.7.4-gentoo; KDE/4.9.5; x86_64; ; )
In-reply-to: <20130205.122252.570646990867457667.hdoyu@nvidia.com>
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com>
 <5110C3E5.2010503@nvidia.com>
 <20130205.122252.570646990867457667.hdoyu@nvidia.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQV3LhwKBBnPfm1hc3jWHzaLzyyw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKefGMv2CZY8Xb1NeYGxjW8XYycHBICJhLP79xlgrDF
	JC7cW8/WxcjFISQwnVGi4/pZVginhUni/JepYFVsAmoSnxsesYHYIgIaElO6HrODFDELPGKS
	WPRlLztIQljAVGL5ve3MIDaLgKrEg8WTgGwODl4BTYmN54JAwvwC6hLvtj0Fmykq4CyxsPc1
	2ExOASeJd3uOM0Esns0oMfPUFlaQBK+AoMSPyfdYQGxmAXmJffunskLYWhLrdx5nmsAoOAtJ
	2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERykz6R2MK5ssDjEKMDBqMTD
	++Myf6AQa2JZcWXuIUYJDmYlEd6PN4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeRlPPQkQEkhP
	LEnNTk0tSC2CyTJxcEo1MIa9lfe6Z/W6RcnmjIr3TtmSI2c2cKo8ty2p6F/lm316ZdHyTo1g
	td4ZO5t987VED528Vxc/zTDkvCGbl4SP2P9thfX8eoyJm3+yzE8TK7Ss+JvPn/tYY3nznd5d
	PULNj/KmrC/+mrhnaV7ong1K1id1miynRFrVGNrpTVuubKMXdFlWZv5TJZbijERDLeai4kQA
	/TXdpU4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 of February 2013 11:22:52 Hiroshi Doyu wrote:
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Tue, 5 Feb 2013 09:33:41 
+0100:
> > > The members of "clk_composite_ops" seems to be always assigned
> > > statically. Istead of dynamically allocating/assigning, can't we
> > > just
> > > have "clk_composite_ops" statically as below?
> > > 
> > > static struct clk_ops clk_composite_ops = {
> > > 
> > > 	.get_parent = clk_composite_get_parent;
> > > 	.set_parent = clk_composite_set_parent;
> > > 	.recalc_rate = clk_composite_recalc_rate;
> > > 	.round_rate = clk_composite_round_rate;
> > > 	.set_rate = clk_composite_set_rate;
> > > 	.is_enabled = clk_composite_is_enabled;
> > > 	.enable = clk_composite_enable;
> > > 	.disable = clk_composite_disable;
> > > 
> > > };
> > > 
> > > struct clk *clk_register_composite(struct device *dev, const char
> > > *name,> > 
> > > 		       const char **parent_names, int num_parents,
> > > 		       struct clk_hw *mux_hw, const struct clk_ops 
*mux_ops,
> > > 		       struct clk_hw *div_hw, const struct clk_ops 
*div_ops,
> > > 		       struct clk_hw *gate_hw, const struct clk_ops 
*gate_ops,
> > > 		       unsigned long flags)
> > > 
> > > {
> > > 
> > > 	.....
> > > 	
> > > 	init.ops = &clk_composite_ops;
> > 
> > No, clk_ops depends on the clocks you are using. There could be a
> > clock
> > with mux and gate while another one with mux and div.
> 
> You are right. What about the following? We don't have to have similar
> copy of clk_composite_ops for each instances.
> 
> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
> index f30fb4b..8f88805 100644
> --- a/drivers/clk/clk-composite.c
> +++ b/drivers/clk/clk-composite.c
> @@ -27,6 +27,9 @@ static u8 clk_composite_get_parent(struct clk_hw *hw)
>         const struct clk_ops *mux_ops = composite->mux_ops;
>         struct clk_hw *mux_hw = composite->mux_hw;
> 
> +       if (!mux_hw->clk)
> +	       return -EINVAL;
> +

Or maybe even:

		if (!mux_ops)

This would be more self-explanatory and save one dereference.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

