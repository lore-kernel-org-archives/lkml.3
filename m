Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab3BZJUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:20:42 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60760 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BZJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:20:04 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [v1][PATCH 7/7] book3e/kexec/kdump: recover "r4 = 0" to create the initial TLB
Date: Tue, 26 Feb 2013 17:19:42 +0800
Message-ID: <1361870382-743-8-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361870382-743-1-git-send-email-tiejun.chen@windriver.com>
References: <1361870382-743-1-git-send-email-tiejun.chen@windriver.com>
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
index 038e81d..e60f078 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -129,6 +129,10 @@ __secondary_hold:
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

