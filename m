Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaACPoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 10:44:13 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:52949 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaACPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:44:12 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] metag/smp: Make boot_secondary() static
Date: Fri,  3 Jan 2014 16:43:51 +0100
Message-Id: <1388763831-27357-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

boot_secondary() is not used outside arch/metag/kernel/smp.c, hence make it
static.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/metag/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 7c0113142981..fc4b80e1e06a 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -68,7 +68,7 @@ static DECLARE_COMPLETION(cpu_running);
 /*
  * "thread" is assumed to be a valid Meta hardware thread ID.
  */
-int boot_secondary(unsigned int thread, struct task_struct *idle)
+static int boot_secondary(unsigned int thread, struct task_struct *idle)
 {
 	u32 val;
 
-- 
1.7.9.5

