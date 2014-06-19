Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaFSMWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:22:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35870 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950AbaFSMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:22:48 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: Leif Lindholm <leif.lindholm@linaro.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] efi: fix build warning about of_get_flat_dt_prop
Date: Thu, 19 Jun 2014 20:22:32 +0800
Message-ID: <1403180552-9272-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9d0c4dfed(of/fdt: update of_get_flat_dt_prop in prep for libfdt)
change the of_get_flat_dt_prop, so update related variable to fix build
warning. Btw, remove unused variable 'name'.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/firmware/efi/efi.c |    5 ++---
 drivers/firmware/efi/fdt.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb..e6da090 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,10 +353,9 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
-	void *prop, *dest;
-	unsigned long len;
+	const void *prop, *dest;
+	int len, i;
 	u64 val;
-	int i;
 
 	if (depth != 1 ||
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8..82d7741 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -63,7 +63,7 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	 */
 	prev = 0;
 	for (;;) {
-		const char *type, *name;
+		const char *type;
 		int len;
 
 		node = fdt_next_node(fdt, prev, NULL);
-- 
1.7.1


