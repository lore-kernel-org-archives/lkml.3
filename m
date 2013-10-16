Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566Ab3JPNvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:51:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60958 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934350Ab3JPNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:19 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 4/5] efi: Move efi_status_to_err() to efi.h
Date: Wed, 16 Oct 2013 14:50:59 +0100
Message-Id: <1381931460-6999-5-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
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
index ac9a4ea..6ff19ff 100644
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
index eed69c9..6a10640 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -753,6 +753,39 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
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
1.8.1.4

