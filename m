Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaEOH5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:57:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52740 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751770AbaEOH5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:57:02 -0400
Date: Thu, 15 May 2014 09:56:59 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] clk: berlin: add driver for BG2x complex
 divider cells
Message-ID: <20140515075659.GP29318@piout.net>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400098522-14770-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400098522-14770-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/2014 at 22:15:16 +0200, Sebastian Hesselbarth wrote :
> +static u8 berlin2_div_get_parent(struct clk_hw *hw)
> +{
> +	struct berlin2_div *div = to_berlin2_div(hw);
> +	struct berlin2_div_map *map = &div->map;
> +	u32 reg;
> +	u8 index = 0;
> +
> +	if (div->lock)
> +		spin_lock(div->lock);
> +
> +	/* PLL_SWITCH == 0 is index 0 */
> +	reg = readl_relaxed(div->base + map->pll_switch_offs);
> +	reg &= BIT(map->pll_switch_shift);
> +	if (reg) {
> +		reg = readl_relaxed(div->base + map->pll_select_offs);
> +		reg >>= map->pll_select_shift;
> +		reg &= PLL_SELECT_MASK;
> +		index = 1 + reg;

After getting more insight, I think we don't need to add 1, see my
comment on the next patchs.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
