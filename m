Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3JVQNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:61569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3JVQNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="415251786"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        perex@perex.cz
Subject: [PATCH 04/11] asmlinkage, pnp: Make variables used from assembler code visible
Date: Tue, 22 Oct 2013 09:12:19 -0700
Message-Id: <1382458346-24811-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Mark variables referenced from assembler files visible.

This fixes compile problems with LTO

Cc: perex@perex.cz
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/pnp/pnpbios/bioscalls.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 769d265..deb7f4b 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -21,7 +21,7 @@
 
 #include "pnpbios.h"
 
-static struct {
+__visible struct {
 	u16 offset;
 	u16 segment;
 } pnp_bios_callpoint;
@@ -41,6 +41,7 @@ asmlinkage void pnp_bios_callfunc(void);
 
 __asm__(".text			\n"
 	__ALIGN_STR "\n"
+	".globl pnp_bios_callfunc\n"
 	"pnp_bios_callfunc:\n"
 	"	pushl %edx	\n"
 	"	pushl %ecx	\n"
@@ -66,9 +67,9 @@ static struct desc_struct bad_bios_desc = GDT_ENTRY_INIT(0x4092,
  * after PnP BIOS oopses.
  */
 
-u32 pnp_bios_fault_esp;
-u32 pnp_bios_fault_eip;
-u32 pnp_bios_is_utter_crap = 0;
+__visible u32 pnp_bios_fault_esp;
+__visible u32 pnp_bios_fault_eip;
+__visible u32 pnp_bios_is_utter_crap = 0;
 
 static spinlock_t pnp_bios_lock;
 
-- 
1.8.3.1

