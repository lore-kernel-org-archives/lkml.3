Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaBDCQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 21:16:00 -0500
Received: from mail-pb0-f74.google.com ([209.85.160.74]:50142 "EHLO
	mail-pb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbaBDCPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 21:15:35 -0500
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH] security: select correct default LSM_MMAP_MIN_ADDR on arm on arm64
Date: Mon,  3 Feb 2014 18:15:32 -0800
Message-Id: <1391480133-27149-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Binaries compiled for arm may run on arm64 if CONFIG_COMPAT is
selected.  Set LSM_MMAP_MIN_ADDR to 32768 if ARM64 && COMPAT to
prevent selinux failures launching 32-bit static executables that
are mapped at 0x8000.

Signed-off-by: Colin Cross <ccross@android.com>
---
 security/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac724fef..beb86b500adf 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -103,7 +103,7 @@ config INTEL_TXT
 config LSM_MMAP_MIN_ADDR
 	int "Low address space for LSM to protect from user allocation"
 	depends on SECURITY && SECURITY_SELINUX
-	default 32768 if ARM
+	default 32768 if ARM || (ARM64 && COMPAT)
 	default 65536
 	help
 	  This is the portion of low virtual memory which should be protected
-- 
1.9.0.rc1.175.g0b1dcb5

