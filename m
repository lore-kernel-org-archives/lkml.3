Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbbALSFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbbALSFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 030/216] arm64: Add COMPAT_HWCAP_LPAE
Date: Mon, 12 Jan 2015 18:02:27 +0000
Message-Id: <1421085933-32536-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 7d57511d2dba03a8046c8b428dd9192a4bfc1e73 upstream.

Commit a469abd0f868 (ARM: elf: add new hwcap for identifying atomic
ldrd/strd instructions) introduces HWCAP_ELF for 32-bit ARM
applications. As LPAE is always present on arm64, report the
corresponding compat HWCAP to user space.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/hwcap.h | 1 +
 arch/arm64/kernel/setup.c      | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 024c46183c3c..0ad735166d9f 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -30,6 +30,7 @@
 #define COMPAT_HWCAP_IDIVA	(1 << 17)
 #define COMPAT_HWCAP_IDIVT	(1 << 18)
 #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
+#define COMPAT_HWCAP_LPAE	(1 << 20)
 #define COMPAT_HWCAP_EVTSTRM	(1 << 21)
 
 #define COMPAT_HWCAP2_AES	(1 << 0)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 46d1125571f6..9e03a1485cc3 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -71,7 +71,8 @@ EXPORT_SYMBOL_GPL(elf_hwcap);
 				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
 				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
 				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
-				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
+				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
+				 COMPAT_HWCAP_LPAE)
 unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
 unsigned int compat_elf_hwcap2 __read_mostly;
 #endif
-- 
2.1.4

