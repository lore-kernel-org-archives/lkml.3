Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaFBKbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:31:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54990 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752805AbaFBKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:31:16 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] efi: Fix compiler warnings (unused, const, type)
Date: Mon,  2 Jun 2014 11:31:06 +0100
Message-Id: <1401705066-2808-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few compiler warning in the efi code for unused
variable, discarding const qualifier and wrong pointer type:

drivers/firmware/efi/fdt.c|66 col 22| warning: unused variable ‘name’ [-Wunused-variable]
drivers/firmware/efi/efi.c|368 col 3| warning: passing argument 3 of ‘of_get_flat_dt_prop’ from incompatible pointer type [enabled by default]
drivers/firmware/efi/efi.c|368 col 8| warning: assignment discards ‘const’ qualifier from pointer target type [enabled by default]

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

Matt,

Unless you have fixed these already, please consider applying (warnings in
latest next/master branch).

Thanks,

Catalin


 drivers/firmware/efi/efi.c | 6 +++---
 drivers/firmware/efi/fdt.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb619fa..eff1a2f22f09 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,10 +353,10 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
-	void *prop, *dest;
-	unsigned long len;
+	const void *prop;
+	void *dest;
 	u64 val;
-	int i;
+	int i, len;
 
 	if (depth != 1 ||
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 5c6a8e8a9580..82d774161cc9 100644
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
