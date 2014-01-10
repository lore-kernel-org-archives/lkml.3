Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaAJQbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:31:15 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51138 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbaAJQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:30:45 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V6 8/8] Add config EFI_STUB for ARM to Kconfig
Date: Fri, 10 Jan 2014 08:30:17 -0800
Message-Id: <1389371417-379-9-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patches have added the implementation of the EFI stub
functionality to the kernel, so now the Kconfig support is added
to enable it.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ab24cc..b650a38 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1867,6 +1867,17 @@ config EFI
 	  However, even with this option, the resultant kernel will
 	  continue to boot on non-UEFI platforms.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on EFI && !CPU_BIG_ENDIAN
+	---help---
+	  This kernel feature allows a zImage to be loaded directly by EFI
+	  firmware without the use of a bootloader.  A PE/COFF header is
+	  added to the zImage in a way that makes the binary both a Linux
+	  zImage and an PE/COFF executable that can be executed directly by
+	  EFI firmware.
+	  See Documentation/efi-stub.txt for more information.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-- 
1.7.10.4

