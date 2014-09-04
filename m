Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaIDRka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:40:30 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45807 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaIDRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:40:28 -0400
Date: Thu, 4 Sep 2014 10:40:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, heiko@sntech.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org, akpm@linux-foundation.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        olof@lixom.net, sonnyrao@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v9 2/3] clk: RK808: Add clkout driver for RK808
Message-ID: <20140904174024.GD10224@core.coreip.homeip.net>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
 <1409793159-2573-3-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409793159-2573-3-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Thu, Sep 04, 2014 at 09:12:38AM +0800, Chris Zhong wrote:
> +	rk808_clkout->clk_data.clks = clk_table;
> +	rk808_clkout->clk_data.clk_num = RK808_NR_OUTPUT;
> +
> +	return of_clk_add_provider(node, of_clk_src_onecell_get,
> +				   &rk808_clkout->clk_data);
> +}
> +
> +static struct platform_driver rk808_clkout_driver = {
> +	.probe = rk808_clkout_probe,
> +	.driver		= {
> +		.name	= "rk808-clkout",
> +	},
> +};

Shouldn't there also be:

static int rk808_clkout_probe(struct platform_device *pdev)
{
	of_clk_del_provider(pdev->dev.of_node);

	/* The rest of resources are managed ones */

	return 0;
}

Thanks.

-- 
Dmitry
