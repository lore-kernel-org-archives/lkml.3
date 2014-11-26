Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaKZRtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:49:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:58683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaKZRtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:49:08 -0500
Message-ID: <5476128D.6070400@kernel.org>
Date: Thu, 27 Nov 2014 02:49:01 +0900
From: Kukjin Kim <kgene@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: EXYNOS: use u8 for val[] in struct exynos_pmu_conf
References: <1787532.9Q2MHGpzCz@amdc1032>
In-Reply-To: <1787532.9Q2MHGpzCz@amdc1032>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/14 02:21, Bartlomiej Zolnierkiewicz wrote:
> Values stored in val[] are never bigger than a byte.
> 
>    text    data     bss     dec     hex filename
>    7716    3692       8   11416    2c98 arch/arm/mach-exynos/pmu.o.before
>    5436    1908       8    7352    1cb8 arch/arm/mach-exynos/pmu.o.after
> 
> Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v2:
> - rebased on top of next-20141126 branch of linux-next kernel tree
>   (it also applies fine to for-next branch of linux-samsung.git)
> 
>  arch/arm/mach-exynos/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
> index ccb0120..c15761c 100644
> --- a/arch/arm/mach-exynos/pmu.c
> +++ b/arch/arm/mach-exynos/pmu.c
> @@ -25,7 +25,7 @@
>  
>  struct exynos_pmu_conf {
>  	unsigned int offset;
> -	unsigned int val[NUM_SYS_POWERDOWN];
> +	u8 val[NUM_SYS_POWERDOWN];
>  };
>  
>  struct exynos_pmu_data {

Applied, thanks.

- Kukjin
