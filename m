Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3BIRyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:54:55 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:34574 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770Ab3BIRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:54:54 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] s390: Add missing PAGE_SHARED as an alias for PAGE_RW
Date: Sat,  9 Feb 2013 18:54:45 +0100
Message-Id: <1360432485-25726-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 allmodconfig:

drivers/gpu/drm/udl/udl_fb.c:237:52: error: 'PAGE_SHARED' undeclared (first use in this function)
drivers/media/pci/zoran/zoran_driver.c:2955:14: error: 'PAGE_SHARED' undeclared (first use in this function)
drivers/media/usb/cpia2/cpia2_core.c:2405:66: error: 'PAGE_SHARED' undeclared (first use in this function)
drivers/video/udlfb.c:337:52: error: 'PAGE_SHARED' undeclared (first use in this function)
drivers/video/smscufx.c:795:52: error: 'PAGE_SHARED' undeclared (first use in this function)
drivers/video/vfb.c:431:52: error: 'PAGE_SHARED' undeclared (first use in this function)

According to an email from Martin a few years ago, the equivalent define
for s390 is PAGE_RW, so make PAGE_SHARED an alias for PAGE_RW.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/s390/include/asm/pgtable.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 098adbb..0ca3e62 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -386,6 +386,7 @@ extern unsigned long MODULES_END;
 
 #define PAGE_KERNEL	PAGE_RW
 #define PAGE_COPY	PAGE_RO
+#define PAGE_SHARED	PAGE_RW
 
 /*
  * On s390 the page table entry has an invalid bit and a read-only bit.
-- 
1.7.0.4

