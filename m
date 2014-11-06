Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKFWlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58754 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaKFWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/162] sparc64: Fix hibernation code refrence to PAGE_OFFSET.
Date: Thu,  6 Nov 2014 14:35:04 -0800
Message-Id: <1415313426-9622-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 9d0713edf72461438bc3526e4ea55fec47754cd9 ]

We changed PAGE_OFFSET to be a variable rather than a constant,
but this reference here in the hibernate assembler got missed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/power/hibernate_asm.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/power/hibernate_asm.S b/arch/sparc/power/hibernate_asm.S
index 7994216..d7d9017 100644
--- a/arch/sparc/power/hibernate_asm.S
+++ b/arch/sparc/power/hibernate_asm.S
@@ -54,8 +54,8 @@ ENTRY(swsusp_arch_resume)
 	 nop
 
 	/* Write PAGE_OFFSET to %g7 */
-	sethi	%uhi(PAGE_OFFSET), %g7
-	sllx	%g7, 32, %g7
+	sethi	%hi(PAGE_OFFSET), %g7
+	ldx	[%g7 + %lo(PAGE_OFFSET)], %g7
 
 	setuw	(PAGE_SIZE-8), %g3
 
-- 
1.9.1

