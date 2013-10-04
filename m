Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3JDQCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:02:33 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:44863 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JDQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:02:32 -0400
From: Roy Franz <roy.franz@linaro.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, hpa@zytor.com
Cc: msalter@redhat.com, patches@linaro.org, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH] Remove redundant and incorrect memset()
Date: Fri,  4 Oct 2013 09:02:46 -0700
Message-Id: <1380902566-30867-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20131003131054.GB27835@gmail.com>
References: <20131003131054.GB27835@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a redundant memset() call from efi_relocate_kernel() that
was clearing memory that would be used by BSS in non-compressed
images loaded with this function.  This clear was redundant with
the clearing done in the image itself, and also implemented incorrectly
with a 0 length.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Acked-by: Mark Salter <msalter@redhat.com>
---
 drivers/firmware/efi/efi-stub-helper.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index cc0581d..b6bffbf 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -567,8 +567,6 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * have been allocated by UEFI, so we can safely use memcpy.
 	 */
 	memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
-	/* Zero any extra space we may have allocated for BSS. */
-	memset((void *)(new_addr + image_size), alloc_size - image_size, 0);
 
 	/* Return the new address of the relocated image. */
 	*image_addr = new_addr;
-- 
1.7.10.4

