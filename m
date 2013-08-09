Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031774Ab3HIX2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:28:37 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45280 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031698Ab3HIX0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:44 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 10/16] Move EFI_READ_CHUNK_SIZE define to shared location.
Date: Fri,  9 Aug 2013 16:26:11 -0700
Message-Id: <1376090777-20090-11-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This #define is only used the the shared code, so move
it there.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.h       |    1 -
 drivers/firmware/efi/efi-stub-helper.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index faa0bdf..bafbd94 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -12,7 +12,6 @@
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
-#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 #define EFI_CONSOLE_OUT_DEVICE_GUID    \
 	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 0f4d6e6..b707a9f 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -9,7 +9,7 @@
  * under the terms of the GNU General Public License version 2.
  *
  */
-
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 struct file_info {
 	efi_file_handle_t *handle;
-- 
1.7.10.4

