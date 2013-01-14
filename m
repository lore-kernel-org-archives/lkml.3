Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab3ANVrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:47:20 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36295 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3ANVrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:47:18 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Jim Quinlan <jim2101024@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] mpis: cavium-octeon/executive/cvmx-l2c.c: fix uninitialized variable
Date: Mon, 14 Jan 2013 22:47:03 +0100
Message-Id: <1358200025-15994-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable dummy is used without initialization.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/mips/cavium-octeon/executive/cvmx-l2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-l2c.c b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
index 9f883bf..d7e07af 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-l2c.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
@@ -286,7 +286,7 @@ uint64_t cvmx_l2c_read_perf(uint32_t counter)
 static void fault_in(uint64_t addr, int len)
 {
 	volatile char *ptr;
-	volatile char dummy;
+	volatile char dummy = 0;
 	/*
 	 * Adjust addr and length so we get all cache lines even for
 	 * small ranges spanning two cache lines.
-- 
1.7.9.5

