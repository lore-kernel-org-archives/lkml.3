Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3I1QXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:23:49 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:54231 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3I1QXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:23:13 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 6/6] Add config EFI_STUB for ARM to Kconfig
Date: Sat, 28 Sep 2013 09:23:23 -0700
Message-Id: <1380385403-31904-7-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..9c84429 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1805,6 +1805,17 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on EFI && !CPU_BIG_ENDIAN
+	---help---
+	  This kernel feature allows a zImage to be loaded directly
+	  by EFI firmware without the use of a bootloader.  A PE/COFF
+	  header is added to the zImage in a way that makes the binary
+	  both a Linux zImage and an PE/COFF executable that can be
+	  executed directly by EFI firmware.
+	  See Documentation/efi-stub.txt for more information.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-- 
1.7.10.4

