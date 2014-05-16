Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbaEPKjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:39:32 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64680 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbaEPKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <1400175151-27779-4-git-send-email-t.figa@samsung.com>
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
	<1400175151-27779-4-git-send-email-t.figa@samsung.com>
Date: Fri, 16 May 2014 16:09:26 +0530
X-Google-Sender-Auth: gvTRaU7OzZeeSUfw5uQv09SEXD8
Message-ID: <CAPdUM4P7Z1eLVKuc0N1iPaekM_7kNv7KCve2MgrEziszfnzz7A@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] clk: samsung: Add driver to control CLKOUT line
 on Exynos SoCs
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> +       gate->lock = &clkout_lock;
> +
> +       mux->reg = reg + EXYNOS_PMU_DEBUG_REG;
> +       mux->mask = EXYNOS_CLKOUT_MUX_MASK;
> +       mux->shift = EXYNOS_CLKOUT_MUX_SHIFT;
> +       mux->lock = &clkout_lock;
> +
> +       clk = clk_register_composite(NULL, "clkout", parent_names,
> +                                       parent_count, &mux->hw,
> +                                       &clk_mux_ops, NULL, NULL, &gate->hw,
> +                                       &clk_gate_ops, 0);
> +       if (IS_ERR(clk))
> +               goto err_unmap;
> +

Hi Tomasz,

Do we really need a composite clock here? How about registering
a mux and a gate separately?

Regards,
Rahul Sharma.

> +       of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +
> +       return;
> +
> +err_unmap:
> +       iounmap(reg);
> +clks_put:
> +       for (i = 0; i < EXYNOS_CLKOUT_PARENTS; ++i)
> +               if (!IS_ERR(parents[i]))
> +                       clk_put(parents[i]);
> +free_gate:
> +       kfree(gate);
> +free_mux:
> +       kfree(mux);
> +
> +       pr_err("%s: failed to register clkout clock\n", __func__);
> +}
> +CLK_OF_DECLARE(exynos4210_clkout, "samsung,exynos4210-pmu", exynos_clkout_init);
> +CLK_OF_DECLARE(exynos4412_clkout, "samsung,exynos4x12-pmu", exynos_clkout_init);
> +CLK_OF_DECLARE(exynos5250_clkout, "samsung,exynos5250-pmu", exynos_clkout_init);
> +CLK_OF_DECLARE(exynos5420_clkout, "samsung,exynos5420-pmu", exynos_clkout_init);
> --
> 1.9.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
