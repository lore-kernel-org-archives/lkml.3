Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaDBL2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:28:00 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47896 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbaDBL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:27:57 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-73-533bf43b410d
Message-id: <533BF433.6000209@samsung.com>
Date: Wed, 02 Apr 2014 13:27:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>
Subject: Re: [PATCH 03/10] ARM: EXYNOS: Move SYSREG definition into sys-reg
 specific file
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-4-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1396425058-4012-4-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7rWX6yDDT7847dYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vFjpbVLA4cHi3NPWwem5fUe/RtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGin2n2Qqe8lXM27mctYHxHHcXIweHhICJxL8t1l2MnECmmMSFe+vZ
	uhi5OIQEljJKfF3RzAThfGKUmPzmGytIFa+AlsSem8uZQWwWAVWJzb8a2EFsNgFDid6jfYwg
	tqhAhMS9xsNQ9YISPybfYwGxRQS0JTov32MFGcoscI9RYurBbiaQhLBAtMSJ6aegVrcySixv
	6ALbwCngIdG8qRFsA7OAjsT+1mlsELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1NLihO
	Ss811CtOzC0uzUvXS87P3cQICfIvOxgXH7M6xCjAwajEwytxySpYiDWxrLgy9xCjBAezkgjv
	pE/WwUK8KYmVValF+fFFpTmpxYcYmTg4pRoY+9n6dLZ3dpjO1Oa4r6u8ObD/357F39L+hx7/
	XHRTc1aN4+/lu179bFLQ+qDtsfHDl16hp2yHlYKe6ew9JGCdulfaguWzwPye+5cS9j5V4Jyj
	b3x4BfNHv+g1OT9YdT+6s04RElrKudND7HW94OKtixfsEHk1T8wqa125Vaa74qSvM9dfCjJx
	UmIpzkg01GIuKk4EAN99b0dQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/04/14 09:50, Pankaj Dubey wrote:
> From: Young-Gun Jang <yg1004.jang@samsung.com>
> 
> While making PMU (Power Mengement Unit) implementation device tree based,
> there are few offsets related with SYSREG present in regs-pmu.h, so let's
> make a new header file "regs-sys.h" to keep all such SYSREG related
> register definition and remove them from "regs-pmu.h"
> 
> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/exynos.c   |    1 +
>  arch/arm/mach-exynos/pm.c       |    1 +
>  arch/arm/mach-exynos/regs-pmu.h |    3 ---
>  arch/arm/mach-exynos/regs-sys.h |   22 ++++++++++++++++++++++
>  4 files changed, 24 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/regs-sys.h
[...]
> diff --git a/arch/arm/mach-exynos/regs-sys.h b/arch/arm/mach-exynos/regs-sys.h
> new file mode 100644
> index 0000000..84332b0
> --- /dev/null
> +++ b/arch/arm/mach-exynos/regs-sys.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * EXYNOS - system register definition
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#ifndef __ASM_ARCH_REGS_SYS_H
> +#define __ASM_ARCH_REGS_SYS_H __FILE__
> +
> +#include <mach/map.h>
> +
> +#define S5P_SYSREG(x)                          (S3C_VA_SYS + (x))
> +
> +/* For EXYNOS5 */
> +#define EXYNOS5_SYS_I2C_CFG                    S5P_SYSREG(0x0234)

Can this be defined as a regular register offset in a header file
placed at include/linux/mfd/syscon/ ? I.e. can the mfd syscon driver be
used instead of these hacks ?

-- 
Thanks,
Sylwester
