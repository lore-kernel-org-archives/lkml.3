Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaHRH74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:59:56 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:47834 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRH7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <1408248374-1638-1-git-send-email-arjun024@gmail.com>
References: <1408248374-1638-1-git-send-email-arjun024@gmail.com>
Date: Mon, 18 Aug 2014 13:29:53 +0530
Message-ID: <CAKohpoke=3vGOoQ9s0snYKZxA_5xMuPtGfAS9uJp1xLJnBwuEA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: exynos: free memory immediately on unknown SoC
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 August 2014 09:36, Arjun Sreedharan <arjun024@gmail.com> wrote:
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 1e0ec57..e47d165 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -178,6 +178,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
>                 ret = exynos5250_cpufreq_init(exynos_info);
>         } else {
>                 pr_err("%s: Unknown SoC type\n", __func__);
> +               kfree(exynos_info);
>                 return -ENODEV;
>         }

Apart from the fact that we could have added some logs and improved
$subject a bit,
it looks fine.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
