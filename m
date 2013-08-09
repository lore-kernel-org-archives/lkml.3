Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031784Ab3HIX1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:27:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40371 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031739Ab3HIX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:55 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 16/16] Add config EFI_STUB for ARM to Kconfig
Date: Fri,  9 Aug 2013 16:26:17 -0700
Message-Id: <1376090777-20090-17-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..8607d03 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1805,6 +1805,17 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on EFI
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

