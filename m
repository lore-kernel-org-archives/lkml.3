Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaBND6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:58:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBND6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:58:39 -0500
Date: Thu, 13 Feb 2014 19:58:21 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a99aa42d0253f033cbb85096d3f2bd82201321e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        perex@perex.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, perex@perex.cz,
        hpa@linux.intel.com
In-Reply-To: <1391845930-28580-4-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-4-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage, pnp:
  Make variables used from assembler code visible
Git-Commit-ID: a99aa42d0253f033cbb85096d3f2bd82201321e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:58:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a99aa42d0253f033cbb85096d3f2bd82201321e6
Gitweb:     http://git.kernel.org/tip/a99aa42d0253f033cbb85096d3f2bd82201321e6
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:00 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:12:27 -0800

asmlinkage, pnp: Make variables used from assembler code visible

Mark variables referenced from assembler files visible.

This fixes compile problems with LTO.

Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-4-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
