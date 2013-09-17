Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3IQEMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:12:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37615 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3IQEL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:11:59 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 10/17] Rename __get_map() to efi_get_memory_map()
Date: Mon, 16 Sep 2013 21:11:26 -0700
Message-Id: <1379391093-27948-11-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename function in preparation for making it more flexible
and sharing it.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4f88e38..7c158cb 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -46,10 +46,10 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 }
 
 
-static efi_status_t __get_map(efi_system_table_t *sys_table_arg,
-			      efi_memory_desc_t **map,
-			      unsigned long *map_size,
-			      unsigned long *desc_size)
+static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				       efi_memory_desc_t **map,
+				       unsigned long *map_size,
+				       unsigned long *desc_size)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -97,7 +97,7 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	u64 max_addr = 0;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -182,7 +182,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	unsigned long nr_pages;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-- 
1.7.10.4

