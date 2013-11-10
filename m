Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3KJOP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 09:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab3KJOP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 09:15:27 -0500
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>, Richard Weinberger <richard@nod.at>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: [PATCH] EFI: Delete out-of-date comments of efi_query_variable_store
Date: Sun, 10 Nov 2013 22:15:11 +0800
Message-ID: <87y54wny1c.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For now we only ensure about 5kb free space for avoiding our board
refusing boot. But the comment lies that we retain 50% space.

Signed-off-by: Madper Xie <cxie@redhat.com>
---
 arch/x86/platform/efi/efi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..1a39d4d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1039,9 +1039,8 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 }
 
 /*
- * Some firmware has serious problems when using more than 50% of the EFI
- * variable store, i.e. it triggers bugs that can brick machines. Ensure that
- * we never use more than this safe limit.
+ * Some firmware implementations refuse to boot if there's insufficient space
+ * in the variable store. Ensure that we never use more than a safe limit.
  *
  * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
  * store.
@@ -1060,10 +1059,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		return status;
 
 	/*
-	 * Some firmware implementations refuse to boot if there's insufficient
-	 * space in the variable store. We account for that by refusing the
-	 * write if permitting it would reduce the available space to under
-	 * 5KB. This figure was provided by Samsung, so should be safe.
+	 * We account for that by refusing the write if permitting it would
+	 * reduce the available space to under 5KB. This figure was provided by
+	 * Samsung, so should be safe.
 	 */
 	if ((remaining_size - size < EFI_MIN_RESERVE) &&
 		!efi_no_storage_paranoia) {
-- 
1.8.4.2

