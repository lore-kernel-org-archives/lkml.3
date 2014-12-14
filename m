Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaLNUsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:48:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaLNUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.10 23/24] powerpc: 32 bit getcpu VDSO function uses 64 bit instructions
Date: Sun, 14 Dec 2014 12:20:43 -0800
Message-Id: <20141214201801.382545773@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 152d44a853e42952f6c8a504fb1f8eefd21fd5fd upstream.

I used some 64 bit instructions when adding the 32 bit getcpu VDSO
function. Fix it.

Fixes: 18ad51dd342a ("powerpc: Add VDSO version of getcpu")
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vdso32/getcpu.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


