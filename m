Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbaGPM6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:58:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59785 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777AbaGPM6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:58:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-2c-53c67700bd04
Message-id: <53C676DB.6070002@samsung.com>
Date: Wed, 16 Jul 2014 14:58:03 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
 <1405505756.4408.24.camel@x220>
In-reply-to: <1405505756.4408.24.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7oM5ceCDWY/M7H4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i0a0zzBardv1hdOD2+P1r
	EqPHzll32T02repk89i8pN7jyokmVo++LasYPbZfm8fssXH7EyaPz5vkAjijuGxSUnMyy1KL
	9O0SuDKWr5jIVLCSu2Ld8c1sDYxzObsYOTkkBEwk5h68wgRhi0lcuLeeDcQWEljKKPHki0cX
	IxeQ/ZlRYvmeX+wgCV4BLYk7J9aBNbAIqEq0n+kFa2ATUJP43PAIzOYHqlnTdJ2li5GDQ1Qg
	QuLxBSGIVkGJH5PvsYDYIgLKEq2b77GDzGcW+Mck0bRsNytIQljAVWLLuavMEIvnMUrceLiN
	EWQQp4COxLSeWpAaZgF1iUnzFjFD2PISm9e8ZZ7AKDgLyY5ZSMpmISlbwMi8ilE0tTS5oDgp
	PddIrzgxt7g0L10vOT93EyMklr7uYFx6zOoQowAHoxIPL8Pso8FCrIllxZW5hxglOJiVRHgd
	/I8FC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBcLmnRaRunu6U871ler/rkKa7iFhd0GV7/SX3p
	2ijk9s00WbIi57uqDfcEp2+KHp5vJoj77DOUFHvy7rlDR8G2wLRTmv5PDjyzWOZZ/bml49sa
	/jOcfpdaFts3M05/drpxzb2jC29eWX2Nxf/TmqULQ54LHnxn5TLj2B/dxZobL6s+V93ONatR
	iaU4I9FQi7moOBEA2fis0IMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 12:15, Paul Bolle wrote:
> On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:

[snip]

>> -config PLAT_S5P
>> -	bool
>> -	depends on ARCH_S5PV210
>> -	default y
>> -	select ARCH_REQUIRE_GPIOLIB
>> -	select ARM_VIC
>> -	select NO_IOPORT_MAP
>> -	select PLAT_SAMSUNG
>> -	select S3C_GPIO_TRACK
>> -	select S5P_GPIO_DRVSTR
>> -	help
>> -	  Base platform code for Samsung's S5P series SoC.
>> -
> 
> After this patch that symbol is still referenced in:
> drivers/media/platform/Kconfig:159:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> drivers/media/platform/Kconfig:169:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> drivers/media/platform/Kconfig:177:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
> drivers/media/platform/exynos4-is/Kconfig:5:    depends on (PLAT_S5P || ARCH_EXYNOS)
> drivers/media/platform/s5p-tv/Kconfig:11:       depends on (PLAT_S5P || ARCH_EXYNOS) && PM_RUNTIME
> drivers/usb/host/Kconfig:223:       depends on PLAT_S5P || ARCH_EXYNOS
> drivers/usb/host/Kconfig:530:   depends on PLAT_S5P || ARCH_EXYNOS
> 
> Again, I assume patches to remove these references are pending. But is
> that correct?

I had two patches fixing those, but apparently this was lost in action.
The correct solution is s/PLAT_S5P/ARCH_S5PV210/. I will include this in
a follow-up series if nobody objects.

Best regards,
Tomasz
