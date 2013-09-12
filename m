Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab3ILIpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab3ILIph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:45:37 -0400
Date: Thu, 12 Sep 2013 16:45:28 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com
Subject: [PATCH] EFI: use nr_tables param directly in efi_config_init
Message-ID: <20130912084528.GA13448@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efi_config_init has the parameter nr_tables. Just use it instead of
dereference efi.systab->nr_tables.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/efi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -599,7 +599,7 @@ static int __init efi_config_init(u64 ta
 
 	tablep = config_tables;
 	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
+	for (i = 0; i < nr_tables; i++) {
 		efi_guid_t guid;
 		unsigned long table;
 
@@ -612,8 +612,7 @@ static int __init efi_config_init(u64 ta
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
-					      efi.systab->nr_tables * sz);
+				early_iounmap(config_tables, nr_tables * sz);
 				return -EINVAL;
 			}
 #endif
@@ -648,7 +647,7 @@ static int __init efi_config_init(u64 ta
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	early_iounmap(config_tables, nr_tables * sz);
 	return 0;
 }
 
