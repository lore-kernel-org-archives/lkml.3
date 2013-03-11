Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3CKDpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 23:45:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52699 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3CKDpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 23:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokJafWjXj8hYT6tgYMGSqgnFCc3MZmNFco2tTeNkOWDmQ@mail.gmail.com>
References: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
	<CAKohpokJafWjXj8hYT6tgYMGSqgnFCc3MZmNFco2tTeNkOWDmQ@mail.gmail.com>
Date: Mon, 11 Mar 2013 09:15:50 +0530
Message-ID: <CADGdYn5hQUmYM5K=-tdsfACXKsJSb=AB+n3N8ATtzD=mFJikMw@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
From: amit kachhap <amit.kachhap@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
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

Hi Viresh,

On Sat, Mar 9, 2013 at 4:17 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 7 March 2013 12:13, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
>> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
>> +struct exynos_dvfs_data {
>> +       void __iomem *base;
>> +       struct resource *mem;
>> +       int irq;
>> +       struct clk *cpu_clk;
>> +       unsigned int cur_frequency;
>> +       unsigned int latency;
>> +       struct cpufreq_frequency_table *freq_table;
>> +       unsigned int freq_count;
>> +       struct device *dev;
>> +       bool dvfs_enable;
>
> s/enable/enabled?
Ok
>
>> +static int exynos_cpufreq_probe(struct platform_device *pdev)
>
>> +       dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
>> +       if (IS_ERR_OR_NULL(dvfs_info->cpu_clk)) {
>
> s/IS_ERR_OR_NULL/IS_ERR
Ok.
>
>> +       if (devm_request_irq(dvfs_info->dev, dvfs_info->irq, exynos_cpufreq_irq,
>> +                               IRQF_TRIGGER_NONE, CPUFREQ_NAME, dvfs_info)) {
>> +               pr_err("Failed to register IRQ\n");
>> +               ret = -ENODEV;
>
> use the value returned from this function rather than creating your
> own.. true for all
> other calls too, unless they return NULL on error.
>
Will integrate your suggestions in the next version.

Thanks,
Amit D
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
