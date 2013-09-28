Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3I1L1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:27:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38551 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3I1L0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:26:50 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 2/2] arm64: include VIRTIO_{MMIO,BLK} in defconfig
Date: Sat, 28 Sep 2013 16:49:56 +0530
Message-Id: <1380367196-28295-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g4cae6f5
In-Reply-To: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
References: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, development on arm64 is aided by a Foundation_v8 emulator
distributed by ARM [1]. To run their kernels, users will execute:

  $ ./Foundation_v8 --image linux-system.axf --block-device raring-rootfs

To mount the raring-rootfs filesystem, the kernel parameter should
typically include:

  root=/dev/vda

For this device to be present, the kernel must be compiled with
VIRTIO_{MMIO,BLK}. To make this work out-of-the-box, make it part of the
default configuration.

[1]: https://silver.arm.com/browse/FM00A

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/arm64/configs/defconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 798bcbb..31c81e9 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -42,7 +42,7 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEVTMPFS=y
-# CONFIG_BLK_DEV is not set
+CONFIG_BLK_DEV=y
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
@@ -91,3 +91,5 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_INFO=y
 # CONFIG_FTRACE is not set
 CONFIG_ATOMIC64_SELFTEST=y
+CONFIG_VIRTIO_MMIO=y
+CONFIG_VIRTIO_BLK=y
-- 
1.8.4.477.g4cae6f5

