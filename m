Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbaLDXsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 18:48:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbaLDXsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 18:48:21 -0500
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, olof@lixom.net,
        lauraa@codeaurora.org
Subject: [PATCH v2] arm64: Enable CONFIG_COMPAT also for 64k page size
Date: Fri,  5 Dec 2014 00:48:19 +0100
Message-Id: <1417736899-115619-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With binutils 2.25 the default alignment for 32bit arm sections changed to
have everything 64k aligned. Armv7 binaries built with this binutils version
run successfully on an arm64 system.

Since effectively there is now the chance to run armv7 code on arm64 even
with 64k page size, it doesn't make sense to block people from enabling
CONFIG_COMPAT on those configurations.

Signed-off-by: Alexander Graf <agraf@suse.de>

---

v1 -> v2:

  - add comment in KConfig explaining that segments need to be 64k aligned
  - conditionalize the option on EXPERT
---
 arch/arm64/Kconfig | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..7fc0ad6 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -409,7 +409,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	bool "Kernel support for 32-bit EL0"
-	depends on !ARM64_64K_PAGES
+	depends on !ARM64_64K_PAGES || EXPERT
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	select OLD_SIGSUSPEND3
@@ -420,6 +420,10 @@ config COMPAT
 	  the user helper functions, VFP support and the ptrace interface are
 	  handled appropriately by the kernel.
 
+	  If you also enabled CONFIG_ARM64_64K_PAGES, please be aware that you
+	  will only be able to execute AArch32 binaries that were compiled with
+	  64k aligned segments.
+
 	  If you want to execute 32-bit userspace applications, say Y.
 
 config SYSVIPC_COMPAT
-- 
1.7.12.4

