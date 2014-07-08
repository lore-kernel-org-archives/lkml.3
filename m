Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaGHP3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:29:24 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51958 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGHP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <1404833138-8244-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1404833138-8244-1-git-send-email-prabhakar.csengg@gmail.com>
Date: Tue, 8 Jul 2014 20:59:22 +0530
Message-ID: <CAKohpokgr-ms9Coj7ViKq9e6K_yE_VzE1upM5UvHkNkAYueWag@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Makefile: fix compilation for davinci platform
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 July 2014 20:55, Lad, Prabhakar <prabhakar.csengg@gmail.com> wrote:
> From patch with commt-id:8a7b1227e303d7e927214ee0f260041aef44bb58
> "cpufreq: davinci: move cpufreq driver to drivers/cpufreq"
> this added dependancy only for CONFIG_ARCH_DAVINCI_DA850 where as
> davinci_cpufreq_init() call is used by all davinci platform.
>
> This patch fixes following build error:
>
> arch/arm/mach-davinci/built-in.o: In function `davinci_init_late':
> :(.init.text+0x928): undefined reference to `davinci_cpufreq_init'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/cpufreq/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 738c8b7..db6d9a2 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -49,7 +49,7 @@ obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)  += arm_big_little.o
>  # LITTLE drivers, so that it is probed last.
>  obj-$(CONFIG_ARM_DT_BL_CPUFREQ)                += arm_big_little_dt.o
>
> -obj-$(CONFIG_ARCH_DAVINCI_DA850)       += davinci-cpufreq.o
> +obj-$(CONFIG_ARCH_DAVINCI)             += davinci-cpufreq.o
>  obj-$(CONFIG_UX500_SOC_DB8500)         += dbx500-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)       += exynos-cpufreq.o
>  obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)   += exynos4210-cpufreq.o

It took one year and 5 kernel releases to catch this again?

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
