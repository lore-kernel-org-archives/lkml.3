Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIEXV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:21:58 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaIEXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:21:56 -0400
From: behanw@converseincode.com
To: catalin.marinas@arm.com, jays.lee@samsung.com, will.deacon@arm.com
Cc: kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, steve.capper@linaro.org,
        sungjinn.chung@samsung.com, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] arm64: LLVMLinux: Add missing abort() for AARCH64
Date: Fri,  5 Sep 2014 16:21:42 -0700
Message-Id: <1409959302-13976-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Add missing abort for arch aarch64.

This patch makes the aarch64 kernel able to compile with gcc or clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/kernel/traps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 02cd3f0..123cd6e 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -349,6 +349,15 @@ void __pgd_error(const char *file, int line, unsigned long val)
 	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
 }
 
+void abort(void)
+{
+	BUG();
+
+	/* if that doesn't kill us, halt */
+	panic("Oops failed to kill thread");
+}
+EXPORT_SYMBOL(abort);
+
 void __init trap_init(void)
 {
 	return;
-- 
1.9.1

