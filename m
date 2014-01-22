Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaAVOmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:42:55 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47225 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaAVOmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com>
References: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 22 Jan 2014 20:12:52 +0530
Message-ID: <CAKohpo=2wR+Sqwxj4koH0rvuk29BkNyAZgN0RR7bVH+3uqpB1Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] cpufreq: exynos: Fix build error of no type of module_init
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2014 19:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Add missing include to fix build error:
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: ‘exynos_cpufreq_platdrv_init’ defined but not used [-Wunused-function]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
> make[1]: *** [drivers/cpufreq] Error 2
>
> Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> and was introduced by commit d568b6f71df1 (cpufreq: exynos: Convert
> exynos-cpufreq to platform driver).
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Lukasz Majewski <l.majewski@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/cpufreq/exynos-cpufreq.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index fcd2914d081a..fa54c2b88dd7 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -17,6 +17,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/cpufreq.h>
>  #include <linux/suspend.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>

I am surprised how that patch went through then? And nothing was
reported by kbuild for it..
