Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3IVWpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:45:46 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63230 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3IVWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:41 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 18/18] resolve warnings found on ARM compile
Date: Sun, 22 Sep 2013 15:45:42 -0700
Message-Id: <1379889942-3135-19-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warnings from gcc:
warning: label 'free_pool' defined but not used [-Wunused-label]
warning: value computed is not used [-Wunused-value]




Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4e4127b..2d22aa3 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -169,7 +169,6 @@ again:
 		*addr = max_addr;
 	}
 
-free_pool:
 	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 
 fail:
@@ -242,7 +241,6 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-free_pool:
 	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 fail:
 	return status;
@@ -358,7 +356,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 			if (*str == '/') {
 				*p++ = '\\';
-				*str++;
+				str++;
 			} else {
 				*p++ = *str++;
 			}
-- 
1.7.10.4

