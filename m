Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaCYRW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaCYRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:22:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 47/81] xtensa: clean up stpill_registers
Date: Tue, 25 Mar 2014 10:16:00 -0700
Message-Id: <1395767794-5012-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 4e96274e2b7a7463de6849c0411d876182ee8889 upstream.

- remove unused asm parameters;
- fix EXCM bit setting in the PS SR during _spill_registers call.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
[ kamal: 3.8-stable prereq for
  "e2fd137 xtensa: introduce spill_registers_kernel macro" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/include/asm/traps.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/include/asm/traps.h b/arch/xtensa/include/asm/traps.h
index b5464ef..917488a 100644
--- a/arch/xtensa/include/asm/traps.h
+++ b/arch/xtensa/include/asm/traps.h
@@ -22,10 +22,9 @@ extern void do_unhandled(struct pt_regs *regs, unsigned long exccause);
 
 static inline void spill_registers(void)
 {
-	unsigned int a0, ps;
 
 	__asm__ __volatile__ (
-		"movi	a14, " __stringify(PS_EXCM_BIT | LOCKLEVEL) "\n\t"
+		"movi	a14, "__stringify((1 << PS_EXCM_BIT) | LOCKLEVEL)"\n\t"
 		"mov	a12, a0\n\t"
 		"rsr	a13, sar\n\t"
 		"xsr	a14, ps\n\t"
@@ -35,7 +34,7 @@ static inline void spill_registers(void)
 		"mov	a0, a12\n\t"
 		"wsr	a13, sar\n\t"
 		"wsr	a14, ps\n\t"
-		: : "a" (&a0), "a" (&ps)
+		: :
 #if defined(CONFIG_FRAME_POINTER)
 		: "a2", "a3", "a4",       "a11", "a12", "a13", "a14", "a15",
 #else
-- 
1.8.3.2

