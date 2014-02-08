Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaBHHxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaBHHw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471774444"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, perex@perex.cz
Subject: [PATCH 04/14] asmlinkage, pnp: Make variables used from assembler code visible
Date: Sat,  8 Feb 2014 08:52:00 +0100
Message-Id: <1391845930-28580-4-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.8.5.2

