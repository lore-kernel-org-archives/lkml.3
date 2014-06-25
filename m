Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbaFYQTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:19:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18635 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbaFYQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:19:11 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7c-53aaf67ce631
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 0/2] Firmware-assisted suspend/resume of Exynos SoCs
Date: Wed, 25 Jun 2014 18:18:32 +0200
Message-id: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Vd2ab6uCDbreCFh8f3iK1eLvpGPs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77Banrn9ms7gxvYXVYv2M1ywWq3b9YXTg
	8Whp7mHz+P1rEqPHzll32T02L6n3uHKiidWjt/kdm0ffllWMHp83yQVwRHHZpKTmZJalFunb
	JXBlPHz5haWgkbviWk8XUwNjN2cXIweHhICJxJuDfl2MnECmmMSFe+vZuhi5OIQEljJKLH68
	kAnC6WOSeHN7KgtIFZuAmsTnhkdsILaIgKrE57YF7CBFzAKrmSVOfW1mB0kIC7hI3FiyAayB
	BahoeucVVhCbV8BJ4ubuc6wQ6+Qkere9YZ7AyL2AkWEVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkjIfd3BuPSY1SFGAQ5GJR7eAJ5VwUKsiWXFlbmHGCU4mJVEeKOeA4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUwBk8ItCxNaDHn3ChVH7rmy8QJB3MKV+4py1I3YDH4N5P7suCXKIbrn/Im
	8N58GtNr5Vx4U8iZR3jNS+Y798y52JfPWJfBlVRV9K2VeVPLXp2zp7NVgsXm6rwMjZh9amfT
	DXk1o5zllkd8c2QtO9TaD0h1dhvxHHxnc7Z+TlP85dulWT/Lv1crsRRnJBpqMRcVJwIAR6OB
	xxcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos-based boards running secure firmware the sequence of low level
operations to enter and leave system-wide sleep mode is different than
on those without the firmware. Namely:
 - CP15 power control and diagnostic registers cannot be written directly,
 - the way of setting boot address and boot flag is different,
 - different resume handler needs to be used (generic cpu_resume() vs
   exynos_cpu_resume()),
 - dedicated SMC call needs to be performed instead of letting the CPU enter
   WFI.

This series introduces .suspend() and .resume() firmware operations to
perform low level firmware-specific suspend and resume and then leverages
them to provide suspend-resume path meeting the above requirements.

The series is based on Kgene's for-next branch and tested on
Exynos4412-based Trats2 board (with few board-specific fixes that will be
sent separately) and Exynos4210-based Trats board (without any extra
patches).
 
Tomasz Figa (2):
  ARM: firmware: Introduce suspend and resume operations
  ARM: EXYNOS: Add support for firmware-assisted suspend/resume

 Documentation/arm/firmware.txt  | 28 +++++-------------------
 arch/arm/include/asm/firmware.h |  8 +++++++
 arch/arm/mach-exynos/firmware.c | 47 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c       | 16 +++++++++-----
 4 files changed, 71 insertions(+), 28 deletions(-)

-- 
1.9.3

