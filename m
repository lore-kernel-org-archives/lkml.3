Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaGQNQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:16:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9175 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaGQNQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:16:32 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-85-53c7ccadd2b6
Message-id: <53C7CC88.5040707@samsung.com>
Date: Thu, 17 Jul 2014 15:15:52 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/3] ARM: EXYNOS: Move code from hotplug.c to platsmp.c
References: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xy7przxwPNuhdb2KxccZ6VovXLwwt
	ehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FmuP3GV34PRoae5h89i8pN6jb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4MhrfvmQrOMBZsXjxe+YGxrfsXYwcHBICJhLbrzN3MXICmWIS
	F+6tZ+ti5OIQEljKKHHn6TNWCOczo8SqNTfYQKp4BbQkOlt+gdksAqoSV7YuYQWx2QTUJD43
	PAKL8wPVrGm6zgKyQFQgQuLxBSGIVkGJH5PvsYDMFBF4ySix9/AEMIdZYAqjRPOkpUwgVcIC
	3hI7LiwGO0lIwF2io2k/O4jNKeAhcf38P0YQm1lAR2J/6zQ2CFteYvOat8wTGAVnIVkyC0nZ
	LCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMDXHYxLj1kdYhTgYFTi4f3BdTxY
	iDWxrLgy9xCjBAezkgjvti6gEG9KYmVValF+fFFpTmrxIUYmDk6pBkbXV/73vz9KkrNSdzOv
	2nkhwVYrcP226sq/XBdPMHSzP5JdWadTzZXWHeLLcWlraaqNv6OU8ZWN+wTXL2tsmLd9w+03
	rBX963W3LLroccP7upbjjiSbgj0r2DxDlzBs3zHR/BvX3a0bNdvr97CuuGhztd6yysKRacYS
	llk3eyv+XvkU/rJDUk+JpTgj0VCLuag4EQAv914+XwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 16.07.2014 16:20, Krzysztof Kozlowski wrote:
> Cleanup a little the SMP/hotplug code for Exynos by:
> 1. Moving completely all functions from hotplug.c into the platsmp.c;
> 2. Deleting the hotplug.c file.
> 
> After recent cleanups (e.g. 75ad2ab28f0f "ARM: EXYNOS: use
> v7_exit_coherency_flush macro for cache disabling") there was only CPU
> power down related code in hotplug.c file. Keeping this file does not
> give any benefits.
> 
> The commit only moves code around with one additional observable change:
> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
> CFLAGS are not necessary any more.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile  |  3 --
>  arch/arm/mach-exynos/common.h  |  2 -
>  arch/arm/mach-exynos/hotplug.c | 92 ------------------------------------------
>  arch/arm/mach-exynos/platsmp.c | 74 +++++++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+), 97 deletions(-)
>  delete mode 100644 arch/arm/mach-exynos/hotplug.c
> 

For this and remaining patches from this series:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
