Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaD3GBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:01:04 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42240 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaD3GA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <1398835057-3860-2-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
	<1398835057-3860-2-git-send-email-pankaj.dubey@samsung.com>
Date: Wed, 30 Apr 2014 11:30:59 +0530
Message-ID: <CAK9yfHxfkegFzzJCz4nAkxrHT6FGT0OQ-5RkCdTA3ruo2kU8CA@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] ARM: EXYNOS: Make exynos machine_ops as static
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        VIKAS SAJJANC <vikas.sajjan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 30 April 2014 10:47, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> As machine function ops are used only in this file let's make
> them static.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 3d69e8d..06dcce5 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -198,7 +198,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
>         },
>  };
>
> -void exynos_restart(enum reboot_mode mode, const char *cmd)
> +static void exynos_restart(enum reboot_mode mode, const char *cmd)
>  {
>         struct device_node *np;
>         u32 val = 0x1;
> @@ -239,7 +239,7 @@ void __init exynos_cpufreq_init(void)
>         platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
>  }
>
> -void __init exynos_init_late(void)
> +static void __init exynos_init_late(void)
>  {
>         if (of_machine_is_compatible("samsung,exynos5440"))
>                 /* to be supported later */
> @@ -300,7 +300,7 @@ static void __init exynos_map_io(void)
>                 iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
>  }
>
> -void __init exynos_init_io(void)
> +static void __init exynos_init_io(void)
>  {
>         debug_ll_io_init();


The declarations from common.h should also be removed in this patch to
avoid the below
build errors:

arch/arm/mach-exynos/exynos.c:198:13: error: static declaration of
‘exynos_restart’ follows non-static declaration
 static void exynos_restart(enum reboot_mode mode, const char *cmd)
             ^
In file included from arch/arm/mach-exynos/exynos.c:31:0:
arch/arm/mach-exynos/common.h:22:6: note: previous declaration of
‘exynos_restart’ was here
 void exynos_restart(enum reboot_mode mode, const char *cmd);
      ^
arch/arm/mach-exynos/exynos.c:235:20: error: static declaration of
‘exynos_init_late’ follows non-static declaration
 static void __init exynos_init_late(void)
                    ^
In file included from arch/arm/mach-exynos/exynos.c:31:0:
arch/arm/mach-exynos/common.h:25:6: note: previous declaration of
‘exynos_init_late’ was here
 void exynos_init_late(void);
      ^
arch/arm/mach-exynos/exynos.c:296:20: error: static declaration of
‘exynos_init_io’ follows non-static declaration
 static void __init exynos_init_io(void)
                    ^
In file included from arch/arm/mach-exynos/exynos.c:31:0:
arch/arm/mach-exynos/common.h:21:6: note: previous declaration of
‘exynos_init_io’ was here
 void exynos_init_io(void);


-- 
With warm regards,
Sachin
