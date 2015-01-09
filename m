Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbbAIKc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:32:59 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44618 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757515AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 32/78] powerpc: 32 bit getcpu VDSO function uses 64 bit instructions
Date: Fri,  9 Jan 2015 11:31:41 +0100
Message-Id: <96c357037c54fd77a729ec7370c6a80dd477e844.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 152d44a853e42952f6c8a504fb1f8eefd21fd5fd upstream.

I used some 64 bit instructions when adding the 32 bit getcpu VDSO
function. Fix it.

Fixes: 18ad51dd342a ("powerpc: Add VDSO version of getcpu")
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/kernel/vdso32/getcpu.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso32/getcpu.S b/arch/powerpc/kernel/vdso32/getcpu.S
index 47afd08c90f7..fe7e97a1aad9 100644
--- a/arch/powerpc/kernel/vdso32/getcpu.S
+++ b/arch/powerpc/kernel/vdso32/getcpu.S
@@ -30,8 +30,8 @@
 V_FUNCTION_BEGIN(__kernel_getcpu)
   .cfi_startproc
 	mfspr	r5,SPRN_USPRG3
-	cmpdi	cr0,r3,0
-	cmpdi	cr1,r4,0
+	cmpwi	cr0,r3,0
+	cmpwi	cr1,r4,0
 	clrlwi  r6,r5,16
 	rlwinm  r7,r5,16,31-15,31-0
 	beq	cr0,1f
-- 
2.2.1

