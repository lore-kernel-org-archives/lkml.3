Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaBKJsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:48:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27063 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaBKJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:47:58 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfec7f5-b7fc96d000004885-f6-52f9f1cb9ea6
Content-transfer-encoding: 8BIT
Message-id: <52F9F1CA.2070501@samsung.com>
Date: Tue, 11 Feb 2014 10:47:54 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv2 2/2] arm: Get rid of meminfo
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org>
 <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
In-reply-to: <1391558551-31395-3-git-send-email-lauraa@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xq7qnP/4MMmheamNx/u4hZov/H3Yz
	Wkxad4DJ4v2yHkaLx8v/sVlMXdbGarGj7TibxcopLBYX1plbNC65zGLRu+Aqm8X2zhnsFp92
	72Gx2PT4GqvFxP1n2S0u75rDZnH7Mq/Fp2f/2C1e961htnj/09Hi5ccTLA6iHmvmrWH0aGnu
	YfO43NfL5HF68n4Wj7+rXjB77Jx1l92j4cB5Fo871/aweWxeUu+xc8dnJo++LasYPY7f2M7k
	8XmTXABvFJdNSmpOZllqkb5dAlfGvsfLGAu6xCre3ZvP3MB4n7+LkYNDQsBEYvNy5i5GTiBT
	TOLCvfVsXYxcHEICSxklXvfNZgJJ8AoISvyYfI8FpJ5ZQF7iyKVskDCzgJnEo5Z1zBD1nxgl
	ni9vZ4ao15KYuOoZM0g9i4CqxJsrwiBhNgFDia63XWwgYVGBUIl5c/VAWkUEbjNLPNl8DGwv
	s8BXJokHLYdZQRqEBYwk5sy9yAJiCwk0Mkps/aMDYnMKuEl8f3CVdQKjwCwk581COG8WkvMW
	MDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJ2a87GJceszrEKMDBqMTDq/H1R5AQa2JZ
	cWXuIUYJDmYlEV6l4z+DhHhTEiurUovy44tKc1KLDzEycXBKNTCeTt6oUy13adU5xsvB/5PW
	HNDxUa6y/PB4xVJr68qHeQ/ui7MsmznpiGjMB+/Jp5bmq8yodVywdE6zYGb0urU52+eLn2su
	uG3fm1P06/Mzm670rC2+DA/sF9RZiX781L7R74nVuvUBUw/+WdZ3JUdt3qGD/D2MH1c62k9n
	7RAzTdjhziewJMpViaU4I9FQi7moOBEAm0aOobcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-05 01:02, Laura Abbott wrote:
> memblock is now fully integrated into the kernel and is the prefered
> method for tracking memory. Rather than reinvent the wheel with
> meminfo, migrate to using memblock directly instead of meminfo as
> an intermediate.
>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

This patch fails with SPARSEMEM enabled (tested with v3.14-rc1, 
exynos4_defconfig + oldnoconfig):

arch/arm/mm/init.c: In function ‘free_unused_memmap’:
arch/arm/mm/init.c:442:10: error: ‘prev_bank_end’ undeclared (first use 
in this function)
arch/arm/mm/init.c:442:10: note: each undeclared identifier is reported 
only once for each function it appears in
make[1]: *** [arch/arm/mm/init.o] Error 1
make[1]: *** Waiting for unfinished jobs....


> ---
>   arch/arm/include/asm/mach/arch.h         |    4 +-
>   arch/arm/include/asm/memblock.h          |    3 +-
>   arch/arm/include/asm/setup.h             |   23 ------
>   arch/arm/kernel/atags_parse.c            |    5 +-
>   arch/arm/kernel/setup.c                  |   30 ++------
>   arch/arm/mach-clps711x/board-clep7312.c  |    7 +-
>   arch/arm/mach-clps711x/board-edb7211.c   |   10 +--
>   arch/arm/mach-clps711x/board-p720t.c     |    2 +-
>   arch/arm/mach-footbridge/cats-hw.c       |    2 +-
>   arch/arm/mach-footbridge/netwinder-hw.c  |    2 +-
>   arch/arm/mach-msm/board-halibut.c        |    6 --
>   arch/arm/mach-msm/board-mahimahi.c       |   13 +---
>   arch/arm/mach-msm/board-msm7x30.c        |    3 +-
>   arch/arm/mach-msm/board-sapphire.c       |   13 ++--
>   arch/arm/mach-msm/board-trout.c          |    8 +--
>   arch/arm/mach-orion5x/common.c           |    3 +-
>   arch/arm/mach-orion5x/common.h           |    3 +-
>   arch/arm/mach-pxa/cm-x300.c              |    3 +-
>   arch/arm/mach-pxa/corgi.c                |   10 +--
>   arch/arm/mach-pxa/eseries.c              |    9 +--
>   arch/arm/mach-pxa/poodle.c               |    8 +--
>   arch/arm/mach-pxa/spitz.c                |    9 +--
>   arch/arm/mach-pxa/tosa.c                 |    8 +--
>   arch/arm/mach-realview/core.c            |   11 +--
>   arch/arm/mach-realview/core.h            |    3 +-
>   arch/arm/mach-realview/realview_pb1176.c |    8 +--
>   arch/arm/mach-realview/realview_pbx.c    |   17 ++---
>   arch/arm/mach-s3c24xx/mach-smdk2413.c    |    8 +--
>   arch/arm/mach-s3c24xx/mach-vstms.c       |    8 +--
>   arch/arm/mach-sa1100/assabet.c           |    2 +-
>   arch/arm/mm/init.c                       |   61 ++++++----------
>   arch/arm/mm/mmu.c                        |  115 +++++++++---------------------
>   32 files changed, 133 insertions(+), 284 deletions(-)

(snipped)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

