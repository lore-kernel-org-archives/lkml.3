Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627Ab3BNNtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079Ab3BNNtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/11] ARM warning fixes for arm-soc
Date: Thu, 14 Feb 2013 14:49:16 +0100
Message-Id: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:mDgb43M7tcs1/2QwBrlD+/h0CE1Q2Am/rEdgoVkRzcG
 sdxgGYjGpJFIITG1MR+RnbsD7Hc9ZwgKhFofMLA9dRtNZqIQn0
 4agtGDGg0wci7c6FLybk5kjHWxbRI1gBR1uZfag4a/Gb6xEaGr
 fCvHzs4fEwPwXBoV35oWPBNvtbbBHN5EoknO+Oqz2XQ4m8fzLO
 i4ff+wQde2ru9AAwD5swFRMs31xdumSDR8FniOb/tyXMOKe2du
 bqwlNdPRA/COgnl2Ofwy5gcxVqa/OkZTwh1uvw8gUuacM5mIyG
 uB3bx+pPGg6CWpcYf0rLLqAyNCW3NEgrL/IKWYcWbbKC/+RfD5
 Y30XesqAKlOBXL+zd7DMm6ACfVXnU+HzkBWsH9sQa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of bug fixes, most of which I have posted
at least one time before. I will add them to the
next/fixes-non-critical branch now, unless there are
any last-minute objections.

Arnd Bergmann (11):
  ARM: disable virt_to_bus/virt_to_bus almost everywhere
  ARM: samsung: fix assembly syntax for new gas
  ARM: w90x900: fix legacy assembly syntax
  ARM: shmobile: fix defconfig warning on CONFIG_USB
  ARM: sa1100: don't warn about mach/ide.h
  ARM: integrator/versatile: fix NOMMU warnings
  ARM: integrator: fix build with INTEGRATOR_AP off
  ARM: pick Versatile by default for !MMU
  ARM: mvebu: allow selecting mvebu without Armada XP
  ARM: s3c: i2c: add platform_device forward declaration
  scripts/sortextable: silence script output

 arch/arm/Kconfig                                 |  7 ++++++-
 arch/arm/configs/marzen_defconfig                |  1 -
 arch/arm/configs/shark_defconfig                 |  1 -
 arch/arm/include/asm/dma.h                       |  2 +-
 arch/arm/include/asm/memory.h                    |  2 ++
 arch/arm/mach-integrator/common.h                |  5 -----
 arch/arm/mach-integrator/core.c                  |  2 +-
 arch/arm/mach-integrator/integrator_ap.c         |  2 +-
 arch/arm/mach-integrator/integrator_cp.c         |  2 +-
 arch/arm/mach-mvebu/Makefile                     |  5 +++--
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S | 12 ++++++------
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |  4 ++--
 arch/arm/mach-s3c24xx/pm-h1940.S                 |  2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            | 12 ++++++------
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            | 12 ++++++------
 arch/arm/mach-sa1100/lart.c                      |  3 ---
 arch/arm/mach-versatile/Kconfig                  |  5 +++++
 arch/arm/mach-versatile/core.c                   |  2 +-
 arch/arm/mach-w90x900/include/mach/entry-macro.S |  4 ++--
 arch/arm/plat-samsung/include/plat/debug-macro.S | 18 +++++++++---------
 include/linux/platform_data/i2c-s3c2410.h        |  2 ++
 scripts/sortextable.h                            |  2 +-
 22 files changed, 56 insertions(+), 51 deletions(-)

-- 
1.8.1.2

