Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3JQW0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:26:23 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34122 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3JQW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:26:21 -0400
MIME-Version: 1.0
In-Reply-To: <1382013526-12800-4-git-send-email-pdeschrijver@nvidia.com>
References: <1382013526-12800-1-git-send-email-pdeschrijver@nvidia.com>
	<1382013526-12800-4-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 17 Oct 2013 15:26:20 -0700
X-Google-Sender-Auth: TI36vgmntiJApL2vUrEe4XFnxF4
Message-ID: <CAL1qeaFrm50m0a3csY=04MNQENM_DY5fgBrq5bdsm8dHnLj1gA@mail.gmail.com>
Subject: Re: [PATCH v4 03/15] clk: tegra: common periph_clk_enb_refcnt and clks
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

>  static void __init tegra30_clock_init(struct device_node *np)
>  {
>         struct device_node *node;
> -       int i;
>
>         clk_base = of_iomap(np, 0);
>         if (!clk_base) {
> @@ -1916,8 +1910,11 @@ static void __init tegra30_clock_init(struct device_node *np)
>                 BUG();
>         }
>
> -       if (tegra_clk_set_periph_banks(5) < 0)
> +       clks = tegra_clk_init(clk_max, 5);
> +       if (!clks) {
> +               WARN_ON(1);

Really minor nit: it seems strange that we WARN here for t30, but not
for t114 or t20.

Thanks,
Andrew
