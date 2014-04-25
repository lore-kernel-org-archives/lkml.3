Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaDYVT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:19:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35265 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaDYVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:19:54 -0400
Message-ID: <535AD177.3030700@gmail.com>
Date: Fri, 25 Apr 2014 23:19:51 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v2 05/10] ARM: EXYNOS: Remove regs-pmu.h header dependency
 from pm_domain
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com> <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com> <1398429166-5539-6-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1398429166-5539-6-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25.04.2014 14:32, Pankaj Dubey wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
>
> Current "pm_domain.c" file uses "S5P_INT_LOCAL_PWR_EN" definition from
> "regs-pmu.h" and hence needs to include this header file. As there is
> no other user of "S5P_INT_LOCAL_PWR_EN" definition other than pm_domain,
> to remove "regs-pmu.h" header file dependency from "pm_domain.c"  it's
> better we define this definition in "pm_domain.c" file itself and thus it
> will help in removing header file inclusion from "pm_domain.c".
>
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> ---
>   arch/arm/mach-exynos/pm_domains.c |    2 +-
>   arch/arm/mach-exynos/regs-pmu.h   |    1 -
>   2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
> index fe6570e..f676b0a 100644
> --- a/arch/arm/mach-exynos/pm_domains.c
> +++ b/arch/arm/mach-exynos/pm_domains.c
> @@ -22,7 +22,7 @@
>   #include <linux/of_platform.h>
>   #include <linux/sched.h>
>
> -#include "regs-pmu.h"
> +#define S5P_INT_LOCAL_PWR_EN 0x7

nit: You could indent the value a bit more in case of adding any new 
macros in future. While at it, you could probably also drop the S5P_ 
prefix.

With these fixed, feel free to add my

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
