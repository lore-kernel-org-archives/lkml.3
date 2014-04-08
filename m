Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaDHQJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:09:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37560 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbaDHQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:09:14 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-4c-53441f28ecaf
Message-id: <53441F25.9080801@samsung.com>
Date: Tue, 08 Apr 2014 18:09:09 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com
Subject: Re: [PATCH 05/10] ARM: EXYNOS: Move "regs-pmu" header inclusion in
 common.h
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-6-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1396425058-4012-6-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7oa8i7BBjuP8Fosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DK2HJyK3NBs3TFg1fbGBsYp4t1MXJwSAiYSJzemtnFyAlkiklcuLeerYuRi0NI
	YCmjxK/5d1kgnM+MEk+WvWYGqeIV0JL4e+s+I4jNIqAqcXLibnYQm01ATeJzwyM2EJsfqGZN
	03UWEFtUIELiXuNhVoheQYkfk++BDRURmMYocX1GIzvIFcwC7hJ3zkmBmMICYRKfZ5RD7G0F
	Kjl2EWwvp4CHxItz/8B2MQtYS6yctI0RwpaX2LzmLfMERsFZSFbMQlI2C0nZAkbmVYyiqaXJ
	BcVJ6bmGesWJucWleel6yfm5mxgh4f5lB+PiY1aHGAU4GJV4eCuPOAULsSaWFVfmHmKU4GBW
	EuG9KuUSLMSbklhZlVqUH19UmpNafIiRiYNTqoFRLCmA+WfkThXZxdMV997177WftN214vW5
	f4ny9hrHUvqvsPXFrt3ky2CyPJXdtlqaP2ShW7d4kHHbgyS7jh9Tz7PteTS7WHnmg+XfeITu
	pkz+mzPXJ/janwXVrhr//B5ItZmm1/zmvHv/1OzJbDITm3Puabxo+2TWH8elKfD2xZx6x2vz
	3s5QYinOSDTUYi4qTgQAlgds3VUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 02.04.2014 09:50, Pankaj Dubey wrote:
> There are many machine files under "mach-exynos" including "regs-pmu.h"
> as well as "common.h", so better we move this header inclusion in common.h.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   arch/arm/mach-exynos/common.h  |    1 +
>   arch/arm/mach-exynos/cpuidle.c |    1 -
>   arch/arm/mach-exynos/exynos.c  |    1 -
>   arch/arm/mach-exynos/hotplug.c |    1 -
>   arch/arm/mach-exynos/platsmp.c |    1 -
>   arch/arm/mach-exynos/pm.c      |    1 -
>   arch/arm/mach-exynos/pmu.c     |    1 -
>   7 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index 277a83e..ff28334 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -14,6 +14,7 @@
>
>   #include <linux/reboot.h>
>   #include <linux/of.h>
> +#include "regs-pmu.h"
>
>   void exynos_init_io(void);
>   void exynos_restart(enum reboot_mode mode, const char *cmd);
> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
> index b530231..b9dd8c3 100644
> --- a/arch/arm/mach-exynos/cpuidle.c
> +++ b/arch/arm/mach-exynos/cpuidle.c
> @@ -29,7 +29,6 @@
>   #include <mach/map.h>
>
>   #include "common.h"
> -#include "regs-pmu.h"
>
>   #define REG_DIRECTGO_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
>   			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
> index 57bd1cd..a5e1349 100644
> --- a/arch/arm/mach-exynos/exynos.c
> +++ b/arch/arm/mach-exynos/exynos.c
> @@ -30,7 +30,6 @@
>
>   #include "common.h"
>   #include "mfc.h"
> -#include "regs-pmu.h"
>   #include "regs-sys.h"
>
>   #define L2_AUX_VAL 0x7C470001
> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> index 5eead53..33db6ee 100644
> --- a/arch/arm/mach-exynos/hotplug.c
> +++ b/arch/arm/mach-exynos/hotplug.c
> @@ -22,7 +22,6 @@
>   #include <plat/cpu.h>
>
>   #include "common.h"
> -#include "regs-pmu.h"
>
>   static inline void cpu_enter_lowpower_a9(void)
>   {
> diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
> index d8d1555..3ebb03f 100644
> --- a/arch/arm/mach-exynos/platsmp.c
> +++ b/arch/arm/mach-exynos/platsmp.c
> @@ -29,7 +29,6 @@
>   #include <plat/cpu.h>
>
>   #include "common.h"
> -#include "regs-pmu.h"
>
>   extern void exynos4_secondary_startup(void);
>
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 723c988..875151f 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -34,7 +34,6 @@
>   #include <mach/map.h>
>
>   #include "common.h"
> -#include "regs-pmu.h"
>   #include "regs-sys.h"
>
>   /**
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index 05c7ce1..fb44352 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -16,7 +16,6 @@
>   #include <plat/cpu.h>
>
>   #include "common.h"
> -#include "regs-pmu.h"
>
>   static const struct exynos_pmu_conf *exynos_pmu_config;
>
>

I don't think this is a good idea. It adds hidden indirect dependencies 
between source files and thus reduces maintainability and readability. 
In addition it causes the file to be included even by files that don't 
need it.

Best regards,
Tomasz
