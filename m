Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3JQWdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:33:18 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43096 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab3JQWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:33:14 -0400
MIME-Version: 1.0
In-Reply-To: <1382013526-12800-6-git-send-email-pdeschrijver@nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
	<1382013526-12800-6-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 17 Oct 2013 15:33:13 -0700
X-Google-Sender-Auth: Al27Z5e9RXUZfbNy2DVwb9e2KUs
Message-ID: <CAL1qeaHsun=6NP4fk4tLCDr5XkLn71-y273Qz5hcfMagek3ZPQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/15] clk: tegra: move some PLLC and PLLXC init to clk-pll.c
From: Andrew Bresticker <abrestic@chromium.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> +       val = readl_relaxed(clk_base + pll_params->base_reg);
> +       val_iddq = readl_relaxed(clk_base + pll_params->iddq_reg);
> +
> +       if (val & BIT(30))

BIT(30) -> PLL_BASE_ENABLE?

> +               WARN_ON(val_iddq & BIT(pll_params->iddq_bit_idx));
> +       else {
> +               val_iddq |= BIT(pll_params->iddq_bit_idx);
> +               writel_relaxed(val_iddq, clk_base + pll_params->iddq_reg);
> +       }

Thanks,
Andrew
