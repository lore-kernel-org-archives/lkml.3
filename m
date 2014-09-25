Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaIYIrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:47:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42031 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaIYIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:47:07 -0400
Message-ID: <5423D67F.5050203@samsung.com>
Date: Thu, 25 Sep 2014 17:46:55 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 0/1] ARM: EXYNOS: Fix builds with PM_SLEEP=n
References: <1411568402-24561-1-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1411568402-24561-1-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 23:20, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> This patch fixes builds with CONFIG_PM_SLEEP config option disabled.
> It has been runtime tested on Exynos4210 based Origen board.
>
> Depends on:
> - for-next branch of linux-samsung.git kernel tree
> - [PATCH v7 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with secure
>    firmware enabled
>    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg37073.html)
>
OK, I'll queue this fixup once the AFTR related changes get ack from 
tegra guy, tegra changes are just trivial though....

Thanks,
Kukjin

> Changes since v2:
> (http://www.mail-archive.com/linux-samsung-soc%40vger.kernel.org/msg35430.html)
> - rebased on top of for-next branch of linux-samsung.git kernel tree +
>    [PATCH v7 0/5] ARM: EXYNOS: cpuidle: fix AFTR mode on boards with secure
>    firmware enabled
>    (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg37073.html)
>
> Changes since v1:
> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34079.html)
> - rebased on top of next-20140811
> - fixed OOPS on the first try to enter cpuidle AFTR mode
>    (config with CONFIG_PM_SLEEP=n and CONFIG_ARM_EXYNOS_CPUIDLE=y)
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>
> Bartlomiej Zolnierkiewicz (1):
>    ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y
>
>   arch/arm/mach-exynos/Kconfig   |   5 +
>   arch/arm/mach-exynos/Makefile  |   5 +-
>   arch/arm/mach-exynos/common.h  |   4 +
>   arch/arm/mach-exynos/pm.c      | 338 +-------------------------------------
>   arch/arm/mach-exynos/suspend.c | 356 +++++++++++++++++++++++++++++++++++++++++
>   arch/arm/plat-samsung/Makefile |   1 +
>   6 files changed, 374 insertions(+), 335 deletions(-)
>   create mode 100644 arch/arm/mach-exynos/suspend.c
>

-- 
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
