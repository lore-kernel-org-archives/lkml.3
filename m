Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaJGOmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:42:37 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37960 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaJGOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:42:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/2] efi: Move efi_status_to_err() to efi.h
Date: Tue,  7 Oct 2014 15:42:30 +0100
Message-Id: <1412692951-25478-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Move efi_status_to_err() into the efi.h header as it's generally useful
in all bits of EFI code where there is a need to convert an efi_status_t
to a kernel error value.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/vars.c | 33 ---------------------------------
 include/linux/efi.h         | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index fa3c66bdc1e5..8e8e0c7f38e4 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -237,39 +237,6 @@ check_var_size(u32 attributes, unsigned long size)
 	return fops->query_variable_store(attributes, size);
 }
 
-static int efi_status_to_err(efi_status_t status)
-{
-	int err;
-
-	switch (status) {
-	case EFI_SUCCESS:
-		err = 0;
-		break;
-	case EFI_INVALID_PARAMETER:
-		err = -EINVAL;
-		break;
-	case EFI_OUT_OF_RESOURCES:
-		err = -ENOSPC;
-		break;
-	case EFI_DEVICE_ERROR:
-		err = -EIO;
-		break;
-	case EFI_WRITE_PROTECTED:
-		err = -EROFS;
-		break;
-	case EFI_SECURITY_VIOLATION:
-		err = -EACCES;
-		break;
-	case EFI_NOT_FOUND:
-		err = -ENOENT;
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
 static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor,
 				struct list_head *head)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0949f9c7e872..48d936cf17d3 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1036,6 +1036,39 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 	*addr &= PAGE_MASK;
 }
 
+static inline int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_SUCCESS:
+		err = 0;
+		break;
+	case EFI_INVALID_PARAMETER:
+		err = -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err = -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err = -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err = -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err = -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err = -ENOENT;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 /*
  * EFI Variable support.
  *
-- 
1.9.3

