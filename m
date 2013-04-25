Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab3DYMN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:13:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:6094 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab3DYMN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:13:27 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/1] metag: defconfigs: increase log buffer 8KiB => 128KiB
Date: Thu, 25 Apr 2013 13:13:14 +0100
Message-ID: <1366891994-1989-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_25_13_13_26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Meta defconfigs set the log buffer size to just 8KiB, but with the
fairly recent conversion of the kernel log buffer into a structured
binary format, log messages appear to consume more space in the buffer,
and in some cases it's not big enough to store the entire boot log.

Therefore switch all the defconfigs to use the default size of 128KiB.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/configs/meta1_defconfig     | 1 -
 arch/metag/configs/meta2_defconfig     | 1 -
 arch/metag/configs/meta2_smp_defconfig | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/metag/configs/meta1_defconfig b/arch/metag/configs/meta1_defconfig
index c35a75e..01cd67e 100644
--- a/arch/metag/configs/meta1_defconfig
+++ b/arch/metag/configs/meta1_defconfig
@@ -1,6 +1,5 @@
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
-CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/metag/configs/meta2_defconfig b/arch/metag/configs/meta2_defconfig
index fb31484..643392ba 100644
--- a/arch/metag/configs/meta2_defconfig
+++ b/arch/metag/configs/meta2_defconfig
@@ -1,7 +1,6 @@
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_KALLSYMS_ALL=y
diff --git a/arch/metag/configs/meta2_smp_defconfig b/arch/metag/configs/meta2_smp_defconfig
index 6c7b777..f330673 100644
--- a/arch/metag/configs/meta2_smp_defconfig
+++ b/arch/metag/configs/meta2_smp_defconfig
@@ -1,7 +1,6 @@
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
-CONFIG_LOG_BUF_SHIFT=13
 CONFIG_SYSFS_DEPRECATED=y
 CONFIG_SYSFS_DEPRECATED_V2=y
 CONFIG_KALLSYMS_ALL=y
-- 
1.8.1.2


