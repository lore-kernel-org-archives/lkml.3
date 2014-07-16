Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbaGPMAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:00:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56317 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523AbaGPMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:00:12 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5a-53c669490f61
Message-id: <53C66924.3010303@samsung.com>
Date: Wed, 16 Jul 2014 13:59:32 +0200
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
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2] ARM: EXYNOS: Fix build with PM_SLEEP=n
References: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xa7qemceCDY5/VbXYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbnLr+mc3iyqVTbA7cHi3NPWwe
	m5fUe1w50cTq0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBnX5s5nK7jAWbHu6CumBsYeji5G
	Tg4JAROJ5webWCFsMYkL99azgdhCAksZJX5tCYKwPzNKNK6zBrF5BbQkdrXtZAaxWQRUJT4s
	3AdmswmoSXxueATWyw9Us6bpOksXIweHqECExOMLQhCtghI/Jt8DCnNxiAi8ZJTYe3gCmMMs
	8IBRYtrVx0wgVcICdhKzGxrZIRa7S/xbcoEFxOYU8JBYOWkXWJxZQEdif+s0NghbXmLzmrfM
	ExgFZyFZMgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMTHlx2Mi49ZHWIU
	4GBU4uFlmH00WIg1say4MvcQowQHs5IIr4P/sWAh3pTEyqrUovz4otKc1OJDjEwcnFINjEYL
	F87r756l//eVflfnxMINfM7TIgq/5qV5LF/38vTqA6b+Hsws7759/C391XH/I9Gu77tU5NON
	NlicYmnZZuXaonI/5UhI5uzZzJFe1mlskT8qu8wT9+56xDEpcEU/45vTsmqlQgz55gr/uf2S
	TjrdXb/cOPtJXZ3vwkdKD0pfC/PNdMj+oMRSnJFoqMVcVJwIAJRP18VtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 14.07.2014 09:45, Krzysztof Kozlowski wrote:
> Fix building of exynos defconfig with disabled PM_SLEEP:
> CONFIG_PM_SLEEP=n
> CONFIG_PM_SLEEP_SMP=n
> CONFIG_SUSPEND=n
> by moving functions for power up/down of CPU and cluster to platsmp.c
> 
> The build error messages:
> arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
> arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
> arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
> arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> Changes since v1:
> 1. Use different solution - just move the power up/down functions to a
>    common place instead of adding stubs in common.h. Suggested by Tomasz
>    Figa.
> ---
>  arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
>  2 files changed, 66 insertions(+), 66 deletions(-)
> 

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
