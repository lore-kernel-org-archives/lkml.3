Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3HZDAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:00:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35879 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3HZDAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:00:47 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 8/8] book3e/kexec/kdump: recover "r4 = 0" to create the initial TLB
Date: Mon, 26 Aug 2013 11:00:58 +0800
Message-ID: <1377486058-30379-9-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377486058-30379-1-git-send-email-tiejun.chen@windriver.com>
References: <1377486058-30379-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 96f013f, "powerpc/kexec: Add kexec "hold" support for Book3e
processors", requires that GPR4 survive the "hold" process, for IBM Blue
Gene/Q with with some very strange firmware. But for FSL Book3E, r4 = 1
to indicate that the initial TLB entry for this core already exists so
we still should set r4 with 0 to create that initial TLB.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/head_64.S |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index fa74d20..001b112 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -127,6 +127,10 @@ __secondary_hold:
 	/* Grab our physical cpu number */
 	mr	r24,r3
 	/* stash r4 for book3e */
+#ifdef CONFIG_PPC_FSL_BOOK3E
+	/* we need to setup initial TLB entry. */
+	li	r4,0
+#endif
 	mr	r25,r4
 
 	/* Tell the master cpu we're here */
-- 
1.7.9.5

