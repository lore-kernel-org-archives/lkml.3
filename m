Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3DXLKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:10:42 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:55754 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3DXLKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <5177BC50.6050402@asianux.com>
References: <5177B562.40400@asianux.com>
	<5177BBB4.4040600@asianux.com>
	<5177BC50.6050402@asianux.com>
Date: Wed, 24 Apr 2013 16:40:38 +0530
X-Google-Sender-Auth: LS_InqpVmiFALl5aTe3rKoGOcVM
Message-ID: <CAOh2x==g96h5UhvBjtyrBTjxdkno3WBv5JEsqyT3jqv7x69V6A@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: S5pv210: compiling issue, ARM_S5PV210_CPUFREQ
 need CONFIG_CPU_FREQ_TABLE=y
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 4:34 PM, Chen Gang <gang.chen@asianux.com> wrote:
>
> For arm S5pv210 with allmodconfig, ARM_S5PV210_CPUFREQ need
> CONFIG_CPU_FREQ_TABLE=y, or will cause compiling issue.
>
> The related operation:
> + arm-linux-gnu-ld -EL -p --no-undefined -X --build-id -X -o .tmp_vmlinux1 -T /root/linux-next/arch/arm/kernel/vmlinux.lds arch/arm/kernel/head.o init/built-in.o --start-group usr/built-in.o arch/arm/nwfpe/built-in.o arch/arm/vfp/built-in.o arch/arm/kernel/built-in.o arch/arm/mm/built-in.o arch/arm/common/built-in.o arch/arm/net/built-in.o arch/arm/crypto/built-in.o arch/arm/mach-s5pv210/built-in.o arch/arm/plat-samsung/built-in.o kernel/built-in.o mm/built-in.o fs/built-in.o ipc/built-in.o security/built-in.o crypto/built-in.o block/built-in.o arch/arm/lib/lib.a lib/lib.a arch/arm/lib/built-in.o lib/built-in.o drivers/built-in.o sound/built-in.o firmware/built-in.o net/built-in.o --end-group
>
> The related errors:
> drivers/built-in.o: In function `s5pv210_target':
> drivers/cpufreq/s5pv210-cpufreq.c:225: undefined reference to `cpufreq_frequency_table_target'
> drivers/cpufreq/s5pv210-cpufreq.c:237: undefined reference to `cpufreq_frequency_table_target'
> drivers/built-in.o: In function `s5pv210_verify_speed':
> drivers/cpufreq/s5pv210-cpufreq.c:182: undefined reference to `cpufreq_frequency_table_verify'
> drivers/built-in.o: In function `s5pv210_cpu_init':
> drivers/cpufreq/s5pv210-cpufreq.c:556: undefined reference to `cpufreq_frequency_table_get_attr'
> drivers/cpufreq/s5pv210-cpufreq.c:560: undefined reference to `cpufreq_frequency_table_cpuinfo'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/cpufreq/Kconfig.arm |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index bce2195..bbcd719 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -187,6 +187,7 @@ config ARM_S3C64XX_CPUFREQ
>  config ARM_S5PV210_CPUFREQ
>         bool "Samsung S5PV210 and S5PC110"
>         depends on CPU_S5PV210
> +       select CPU_FREQ_TABLE

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
