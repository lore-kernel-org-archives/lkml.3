Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLOOoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:44:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaLOO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 116/168] powerpc: 32 bit getcpu VDSO function uses 64 bit instructions
Date: Mon, 15 Dec 2014 14:26:10 +0000
Message-Id: <1418653622-21105-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 152d44a853e42952f6c8a504fb1f8eefd21fd5fd upstream.

I used some 64 bit instructions when adding the 32 bit getcpu VDSO
function. Fix it.

Fixes: 18ad51dd342a ("powerpc: Add VDSO version of getcpu")
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/vdso32/getcpu.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso32/getcpu.S b/arch/powerpc/kernel/vdso32/getcpu.S
index 23eb9a9441bd..c62be60c7274 100644
--- a/arch/powerpc/kernel/vdso32/getcpu.S
+++ b/arch/powerpc/kernel/vdso32/getcpu.S
@@ -30,8 +30,8 @@
 V_FUNCTION_BEGIN(__kernel_getcpu)
   .cfi_startproc
 	mfspr	r5,SPRN_SPRG_VDSO_READ
-	cmpdi	cr0,r3,0
-	cmpdi	cr1,r4,0
+	cmpwi	cr0,r3,0
+	cmpwi	cr1,r4,0
 	clrlwi  r6,r5,16
 	rlwinm  r7,r5,16,31-15,31-0
 	beq	cr0,1f
-- 
2.1.3

