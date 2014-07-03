Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaGCAif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:38:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45866 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaGCAid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:38:33 -0400
Message-ID: <53B4A607.7030001@codeaurora.org>
Date: Wed, 02 Jul 2014 17:38:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't registered
 yet
References: <cover.1404231535.git.viresh.kumar@linaro.org> <eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org> <20140702055330.GA3454@dragon> <CAKohpomzPHRghqHD7-tDbj0gXzc=ANEb3qLv2kRKOZUyqatBew@mail.gmail.com> <CAKohpomk-pyv6Risyq_b8h3DJNGxBoUWu1Y9cApvoz3CwOtL=w@mail.gmail.com>
In-Reply-To: <CAKohpomk-pyv6Risyq_b8h3DJNGxBoUWu1Y9cApvoz3CwOtL=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/14 04:32, Viresh Kumar wrote:
>
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index 4273a5f..0c16b2f 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -151,7 +151,16 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
>         cpu_clk = clk_get(cpu_dev, NULL);
>         if (IS_ERR(cpu_clk)) {
>                 ret = PTR_ERR(cpu_clk);
> -               pr_err("failed to get cpu0 clock: %d\n", ret);
> +
> +               /*
> +                * If cpu's clk node is present, but clock is not yet
> +                * registered, we should try defering probe.
> +                */
> +               if (ret == -EPROBE_DEFER)
> +                       dev_err(cpu_dev, "cpu0 clock not ready, retry\n");

Please make this a dev_dbg() or just remove it entirely. Sending a
message to the log on probe defer just duplicates what the driver core
is already doing.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

