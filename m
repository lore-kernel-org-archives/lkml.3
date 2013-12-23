Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3LWOG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:06:56 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53346 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab3LWOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:06:49 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, viro@zeniv.linux.org.uk,
        nico@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/5] ARM: introduce HWCAP2 feature bits for ARMv8 Crypto Extensions
Date: Mon, 23 Dec 2013 15:06:31 +0100
Message-Id: <1387807592-26375-5-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allocates feature bits 0-4 in HWCAP2 for the crypto and CRC
extensions introduced in ARMv8.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/uapi/asm/hwcap.h | 5 +++++
 arch/arm/kernel/setup.c           | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/include/uapi/asm/hwcap.h b/arch/arm/include/uapi/asm/hwcap.h
index 87768b5..20d12f2 100644
--- a/arch/arm/include/uapi/asm/hwcap.h
+++ b/arch/arm/include/uapi/asm/hwcap.h
@@ -31,5 +31,10 @@
 /*
  * HWCAP2 flags - for elf_hwcap2 (in kernel) and AT_HWCAP2
  */
+#define HWCAP2_AES	(1 << 0)
+#define HWCAP2_PMULL	(1 << 1)
+#define HWCAP2_SHA1	(1 << 2)
+#define HWCAP2_SHA2	(1 << 3)
+#define HWCAP2_CRC32	(1 << 4)
 
 #endif /* _UAPI__ASMARM_HWCAP_H */
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ce3049c..ac3a7f2 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -996,6 +996,11 @@ static const char *hwcap_str[] = {
 };
 
 static const char *hwcap2_str[] = {
+	"aes",
+	"pmull",
+	"sha1",
+	"sha2",
+	"crc32",
 	NULL
 };
 
-- 
1.8.3.2

