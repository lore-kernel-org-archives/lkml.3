Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaKNOMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:12:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40722 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaKNOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:12:03 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-f6-54660daf4770
Message-id: <54660DAE.9090601@samsung.com>
Date: Fri, 14 Nov 2014 15:11:58 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v8 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Nd31vGkhBnNeWVj8nXSM3eLR/MfM
	Fr0LrrJZnG16w26xvXMGu8WUP8uZLDY9vsZqcXnXHDaL2Uv6WSxmnN/HZHH7Mq/Fue1bWCyW
	Xr/IZHHq+mc2i1W7/jBa7L/i5SDgsWbeGkaPluYeNo/fvyYxenz7OonF43JfL5PHou9ZHjtn
	3WX3uHNtD5vH5iX1HldONLF69G1ZxejxeZNcAE8Ul01Kak5mWWqRvl0CV8a5jl+sBbOUKlr2
	z2BrYLwu1cXIySEhYCLx8+9uNghbTOLCvfVANheHkMBSRomF92YzQTifGCX+v5rAAlLFK6Al
	cXTxOSCbg4NFQFXibFcNSJhNwFCi620X2CBRgRiJ+ztXs0GUC0r8mHwPrFVEIENi7uxZjCA2
	s8AiZontv+JAbGEBb4nrT/cwg9hCAu4S7bsOg9VwCnhIfFn/hxWi3kziy8vDULa8xOY1b5kn
	MArMQrJiFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIib4vOxgXH7M6xCjA
	wajEw2tQkBoixJpYVlyZe4hRgoNZSYT3+3OgEG9KYmVValF+fFFpTmrxIUYmDk6pBkbe3Qt+
	NHib9xy5YBCRvvXJrTBJBeeIo+pzY5t6mYO87rHJq704PPepT9fsFaX5dz5espg+f7JTjoKB
	nYDm5ulaChklv6v0Jx4+//m83+LaBlu5jj0X/F1vzPX3SNL9+CVrypPqtx1OZ33YV09zyRE5
	rT7ln3E141Pu8jq+3csSiti+H7twNFGJpTgj0VCLuag4EQCD09hdnAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-11-13 14:18, Marek Szyprowski wrote:
> This is an updated patchset, which intends to add support for L2 cache
> on Exynos4 SoCs on boards running under secure firmware, which requires
> certain initialization steps to be done with help of firmware, as
> selected registers are writable only from secure mode.
>
> First four patches extend existing support for secure write in L2C driver
> to account for design of secure firmware running on Exynos. Namely:
>   1) direct read access to certain registers is needed on Exynos, because
>      secure firmware calls set several registers at once,
>   2) not all boards are running secure firmware, so .write_sec callback
>      needs to be installed in Exynos firmware ops initialization code,
>   3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
>      is not allowed and so must use l2c_write_sec as well,
>   4) on certain boards, default value of prefetch register is incorrect
>      and must be overridden at L2C initialization.
> For boards running with firmware that provides access to individual
> L2C registers this series should introduce no functional changes. However
> since the driver is widely used on other platforms I'd like to kindly ask
> any interested people for testing.
>
> Further three patches add implementation of .write_sec and .configure
> callbacks for Exynos secure firmware and necessary DT nodes to enable
> L2 cache.
>
> Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
> boards (both with secure firmware). There should be no functional change
> for Exynos boards running without secure firmware. I do not have access
> to affected non-Exynos boards, so I could not test on them.
>
>
> Depends on:
>   - [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
>     (https://lkml.org/lkml/2014/8/26/445)
>     available in samsung/pm2 branch in
>     git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
>   - L2C patches merged to v3.18-rc3

I assume that after all comments from previous versions, no more changes 
are needed
to this patchset and I would really like to have it queued to v3.19.

Arnd, Olof: could you take this patchset thought arm-soc tree? It already
contains all dependencies.

Kukjin: could you ack this patchset?

> Changelog:
> Changes since v7:
> (https://lkml.org/lkml/2014/10/29/158)
> - rebased onto arm-soc/for-next kernel tree (depends on patches merged to
>    v3.18-rc3 and arm-soc/samsung/pm2 branch)
> - removed 'ARM: l2c: unify L2C-310 OF initialization error messages' patch
>    (no longer needed)
>
> Changes since v6:
> (https://lkml.org/lkml/2014/10/27/233)
> - changed PL310 to L2C-310 prefix in error messages
> - added patch shortening the error message about incorrect associativity
>
> Changes since v5:
> (https://lkml.org/lkml/2014/9/24/364)
> - rebased onto v3.18-rc2
> - added error message about missing properties values
>
> Changes since v4:
> (https://lkml.org/lkml/2014/8/26/461)
>   - rewrote the code accessing l2x0_saved_regs from assembly code
>   - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL
>
>
> Patch summary:
>
> Tomasz Figa (7):
>    ARM: l2c: Refactor the driver to use commit-like interface
>    ARM: l2c: Add interface to ask hypervisor to configure L2C
>    ARM: l2c: Get outer cache .write_sec callback from mach_desc only if
>      not NULL
>    ARM: l2c: Add support for overriding prefetch settings
>    ARM: EXYNOS: Add .write_sec outer cache callback for L2C-310
>    ARM: EXYNOS: Add support for non-secure L2X0 resume
>    ARM: dts: exynos4: Add nodes for L2 cache controller
>
>   Documentation/devicetree/bindings/arm/l2cc.txt |  10 +
>   arch/arm/boot/dts/exynos4210.dtsi              |   9 +
>   arch/arm/boot/dts/exynos4x12.dtsi              |  14 ++
>   arch/arm/include/asm/outercache.h              |   3 +
>   arch/arm/kernel/irq.c                          |   3 +-
>   arch/arm/mach-exynos/firmware.c                |  50 +++++
>   arch/arm/mach-exynos/sleep.S                   |  46 +++++
>   arch/arm/mm/cache-l2x0.c                       | 270 ++++++++++++++++---------
>   8 files changed, 309 insertions(+), 96 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

