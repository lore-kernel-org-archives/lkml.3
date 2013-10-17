Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3JQWPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:15:46 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47456 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3JQWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <1382013526-12800-3-git-send-email-pdeschrijver@nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
	<1382013526-12800-3-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 17 Oct 2013 15:15:43 -0700
X-Google-Sender-Auth: FOT3s8jAkevzlMudxYv6JvphYKE
Message-ID: <CAL1qeaGg+XdCWSp4yjWTFxXjhj8a+_dFwpT+B_H+GQ_CWZ50-A@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] clk: tegra: simplify periph clock data
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> @@ -2346,6 +2247,9 @@ static void __init tegra114_clock_init(struct device_node *np)
>         if (tegra114_osc_clk_init(clk_base) < 0)
>                 return;
>
> +       if (tegra_clk_set_periph_banks(5) < 0)

Maybe it would be better to have a #define for this (e.g.
TEGRAxxx_CLK_PERIPH_BANKS)?  Same goes for t20 and t30.

>  /* Global data of Tegra CPU CAR ops */
>  static struct tegra_cpu_car_ops dummy_car_ops;
>  struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
>
> +int *periph_clk_enb_refcnt;

This changes seems unrelated.  Perhaps it should go in the one that
makes the common periph_clk_enb_refcnt?

Thanks,
Andrew
