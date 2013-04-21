Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3DUXYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:24:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40205 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3DUXYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:24:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, cpufreq@vger.kernel.org,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] cpufreq: exynos5440: Protect opp search calls with rcu lock
Date: Mon, 22 Apr 2013 01:32:17 +0200
Message-ID: <27334831.finUCxlqRS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366007087-12090-1-git-send-email-amit.daniel@samsung.com>
References: <1366007087-12090-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 15, 2013 11:54:47 AM Amit Daniel Kachhap wrote:
> As per the OPP library documentation(Documentation/power/opp.txt) all
> opp find/get calls should be protected by rcu locks.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
> 
> This patch is created against linux-next tree and is suggested by
> Nishanth Menon. (https://lkml.org/lkml/2013/4/12/119)

Applied.

Thanks,
Rafael


>  drivers/cpufreq/exynos5440-cpufreq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> index ead7ed4..0c74018 100644
> --- a/drivers/cpufreq/exynos5440-cpufreq.c
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -120,11 +120,13 @@ static int init_div_table(void)
>  	int i = 0;
>  	struct opp *opp;
>  
> +	rcu_read_lock();
>  	for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
>  
>  		opp = opp_find_freq_exact(dvfs_info->dev,
>  					freq_tbl[i].frequency * 1000, true);
>  		if (IS_ERR(opp)) {
> +			rcu_read_unlock();
>  			dev_err(dvfs_info->dev,
>  				"failed to find valid OPP for %u KHZ\n",
>  				freq_tbl[i].frequency);
> @@ -159,6 +161,7 @@ static int init_div_table(void)
>  		__raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
>  	}
>  
> +	rcu_read_unlock();
>  	return 0;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
