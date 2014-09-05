Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaIEBfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:35:30 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63538 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaIEBf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:35:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Chris Zhong <zyw@rock-chips.com>, dianders@chromium.org, heiko@sntech.de
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1409793159-2573-3-git-send-email-zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, akpm@linux-foundation.org, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com, "Chris Zhong" <zyw@rock-chips.com>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
 <1409793159-2573-3-git-send-email-zyw@rock-chips.com>
Message-ID: <20140905013513.11368.8329@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v9 2/3] clk: RK808: Add clkout driver for RK808
Date: Thu, 04 Sep 2014 18:35:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Zhong (2014-09-03 18:12:38)
> +static int rk808_clkout1_is_prepared(struct clk_hw *hw)
> +{
> +       return 1;
> +}
> +

<snip>

> +static const struct clk_ops rk808_clkout1_ops = {
> +       .is_prepared = rk808_clkout1_is_prepared,
> +       .recalc_rate = rk808_clkout_recalc_rate,
> +};

Hi Chris,

I do not see a need clkout1 to have a .is_prepared callback. You should
be fine only having a .recalc_rate.

Regards,
Mike
