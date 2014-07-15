Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaGORCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:43 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48056 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaGORCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:17 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 59/94] m68k: Fix boot regression on machines with RAM at non-zero
Date: Tue, 15 Jul 2014 20:01:14 +0300
Message-Id: <1405443709-15288-59-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

My enhancement to store the initial mapping size for later reuse in commit
486df8bc4627bdfc032d11bedcd056cc5343ee62 ("m68k: Increase initial mapping
to 8 or 16 MiB if possible") broke booting on machines where RAM doesn't
start at address zero.

Use pc-relative addressing to fix this.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/m68k/kernel/head.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index dbb118e..a547884 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -921,7 +921,8 @@ L(nocon):
 	jls	1f
 	lsrl	#1,%d1
 1:
-	movel	%d1,m68k_init_mapped_size
+	lea	%pc@(m68k_init_mapped_size),%a0
+	movel	%d1,%a0@
 	mmu_map	#PAGE_OFFSET,%pc@(L(phys_kernel_start)),%d1,\
 		%pc@(m68k_supervisor_cachemode)
 
-- 
1.7.10.4

