Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaF3RQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:16:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38783 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaF3RQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:16:15 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3d-53b19b5d1746
Message-id: <53B19B42.1040006@samsung.com>
Date: Mon, 30 Jun 2014 19:15:46 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH v5 5/5] ARM: EXYNOS: Move PMU specific definitions from
 common.h
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-6-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1403705032-14835-6-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7qxszcGG5y+qG6xbNJdNovvu76w
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LT0f/s1os2gpU0bGM0eLms+1MDtweLc09bB6b
	l9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8ahUyeYC75wVTQe6GFqYHzA0cXIySEhYCLx
	Z+ciNghbTOLCvfVANheHkMBSRomVZ7pZIJzPjBIPZq1mAqniFdCSePT0IiuIzSKgKtHx/ScL
	iM0moCbxueER2CR+oJo1TdeB4hwcogIREo8vCEG0Ckr8mHwPbKaIwDRGiYuXbrODOMwCSxgl
	9sw4xQhSJSwQJvG+9wg7xOZ2RolFC0+wgyQ4BTwlri5aBbaNWUBHYn/rNDYIW15i85q3zBMY
	BWch2TILSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTExpcdjIuPWR1iFOBg
	VOLhbVyxIViINbGsuDL3EKMEB7OSCO9Nn43BQrwpiZVVqUX58UWlOanFhxiZODilGhiNGxnO
	q/ucNdunq2N7w830yLHkO29fatkcjgq32V46mXMlz3LemwErpPkZOVYumJvS5pi6Oi3wtTH3
	/FtvmYwnFR44+79rH1PKPJUKwfW20s3L1q09eTKqa8JL/zcn3nWlxpziZzl/QVpnlf6O775H
	dN5ejVjXpLtBXPKmwUm/1KZW03UFoiJKLMUZiYZazEXFiQCiAZ96awIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 25.06.2014 16:03, Pankaj Dubey wrote:
> This patch moves PMU specific definitions into a new file
> as exynos-pmu.h.
> This will help in reducing dependency of common.h in pmu.c.
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h     |   17 -----------------
>  arch/arm/mach-exynos/exynos-pmu.h |   31 +++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/pm.c         |    1 +
>  arch/arm/mach-exynos/pmu.c        |    2 +-
>  4 files changed, 33 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
> 
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index 296c6e1..0326ca2 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -135,23 +135,6 @@ extern struct smp_operations exynos_smp_ops;
>  
>  extern void exynos_cpu_die(unsigned int cpu);
>  
> -/* PMU(Power Management Unit) support */
> -
> -#define PMU_TABLE_END	(-1U)
> -
> -enum sys_powerdown {
> -	SYS_AFTR,
> -	SYS_LPA,
> -	SYS_SLEEP,
> -	NUM_SYS_POWERDOWN,
> -};
> -
> -struct exynos_pmu_conf {
> -	unsigned int offset;
> -	unsigned int val[NUM_SYS_POWERDOWN];
> -};

While at it, I'd say this struct could be moved to pmu.c, along with the
PMU_TABLE_END macro as they are both private to this file.

Best regards,
Tomasz
