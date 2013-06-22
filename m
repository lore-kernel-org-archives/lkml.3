Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423472Ab3FVHlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 03:41:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9299 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3FVHlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 03:41:31 -0400
X-Spam-Score: -100.8
Message-ID: <51C554F4.8060704@asianux.com>
Date: Sat, 22 Jun 2013 15:40:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: chris@zankel.net, Max Filippov <jcmvbkbc@gmail.com>
CC: linux-xtensa@linux-xtensa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: xtensa: include: asm: define '_PAGE_CHG_MASK' when
 'NOMMU'
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define '_PAGE_CHG_MASK' when 'NOMMU' to pass compiling.

The related make:

  make ARCH=xtensa allmodconfig
  make ARCH=xtensa menuconfig
    set "xtensa-linux-gnu-" for "Cross compilier tool prefix"
    select "s6000" for "Processor type and features" -> "Xtensa Processor"
  make ARCH=xtensa EXTRA_CFLAGS=-W

The related error:

  arch/xtensa/include/asm/pgtable.h: In function ‘pte_modify’:
  arch/xtensa/include/asm/pgtable.h:289:9: error: ‘_PAGE_CHG_MASK’ undeclared (first use in this function)


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/xtensa/include/asm/pgtable.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/include/asm/pgtable.h b/arch/xtensa/include/asm/pgtable.h
index 7e09f70..a28c49b 100644
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -149,9 +149,10 @@
 #define _PAGE_DIRTY		(1<<7)	/* software: page dirty */
 #define _PAGE_ACCESSED		(1<<8)	/* software: page accessed (read) */
 
+#define _PAGE_CHG_MASK	   (PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+
 #ifdef CONFIG_MMU
 
-#define _PAGE_CHG_MASK	   (PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _PAGE_PRESENT	   (_PAGE_HW_VALID | _PAGE_CA_WB | _PAGE_ACCESSED)
 
 #define PAGE_NONE	   __pgprot(_PAGE_NONE | _PAGE_USER)
-- 
1.7.7.6
