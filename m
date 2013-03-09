Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3CIKra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 05:47:30 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44001 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3CIKr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 05:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
References: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
Date: Sat, 9 Mar 2013 18:47:26 +0800
Message-ID: <CAKohpokJafWjXj8hYT6tgYMGSqgnFCc3MZmNFco2tTeNkOWDmQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 12:13, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> +struct exynos_dvfs_data {
> +       void __iomem *base;
> +       struct resource *mem;
> +       int irq;
> +       struct clk *cpu_clk;
> +       unsigned int cur_frequency;
> +       unsigned int latency;
> +       struct cpufreq_frequency_table *freq_table;
> +       unsigned int freq_count;
> +       struct device *dev;
> +       bool dvfs_enable;

s/enable/enabled?

> +static int exynos_cpufreq_probe(struct platform_device *pdev)

> +       dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
> +       if (IS_ERR_OR_NULL(dvfs_info->cpu_clk)) {

s/IS_ERR_OR_NULL/IS_ERR

> +       if (devm_request_irq(dvfs_info->dev, dvfs_info->irq, exynos_cpufreq_irq,
> +                               IRQF_TRIGGER_NONE, CPUFREQ_NAME, dvfs_info)) {
> +               pr_err("Failed to register IRQ\n");
> +               ret = -ENODEV;

use the value returned from this function rather than creating your
own.. true for all
other calls too, unless they return NULL on error.

> +}
