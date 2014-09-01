Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaIAAyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaIAAyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:54:14 -0400
From: Laszlo Ersek <lersek@redhat.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com, msalter@redhat.com,
        lersek@redhat.com
Subject: [PATCH 4/5] ia64: efi: format EFI memory type & attrs with efi_md_typeattr_format()
Date: Mon,  1 Sep 2014 02:53:39 +0200
Message-Id: <1409532820-5027-5-git-send-email-lersek@redhat.com>
In-Reply-To: <1409532820-5027-1-git-send-email-lersek@redhat.com>
References: <1409532820-5027-1-git-send-email-lersek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 arch/ia64/kernel/efi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 741b99c..c52d754 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -568,6 +568,7 @@ efi_init (void)
 		{
 			const char *unit;
 			unsigned long size;
+			char buf[64];
 
 			md = p;
 			size = md->num_pages << EFI_PAGE_SHIFT;
@@ -586,9 +587,10 @@ efi_init (void)
 				unit = "KB";
 			}
 
-			printk("mem%02d: type=%2u, attr=0x%016lx, "
+			printk("mem%02d: %s "
 			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
-			       i, md->type, md->attribute, md->phys_addr,
+			       i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			       md->phys_addr,
 			       md->phys_addr + efi_md_size(md), size, unit);
 		}
 	}
-- 
1.8.3.1


