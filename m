Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab3B0DKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:10:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:44499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3B0DJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:09:44 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [v3][PATCH 4/6] powerpc/book3e: support kgdb for kernel space
Date: Wed, 27 Feb 2013 11:09:26 +0800
Message-ID: <1361934568-31989-5-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
References: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we need to skip this for supporting KGDB.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/exceptions-64e.S |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 7df9a1f..800e2a3 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -598,11 +598,14 @@ kernel_dbg_exc:
 	rfdi
 
 	/* Normal debug exception */
+1:
+#ifndef CONFIG_KGDB
 	/* XXX We only handle coming from userspace for now since we can't
 	 *     quite save properly an interrupted kernel state yet
 	 */
-1:	andi.	r14,r11,MSR_PR;		/* check for userspace again */
+	andi.	r14,r11,MSR_PR;		/* check for userspace again */
 	beq	kernel_dbg_exc;		/* if from kernel mode */
+#endif
 
 	/* Now we mash up things to make it look like we are coming on a
 	 * normal exception
-- 
1.7.9.5

