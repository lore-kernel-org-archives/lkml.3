Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3FDRDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565Ab3FDRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 39/75] ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling
Date: Tue,  4 Jun 2013 09:55:23 -0700
Message-Id: <1370364959-9475-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@gmail.com>

commit 934fc24df10abfd5aff533d0d044a17669d77d79 upstream.

Make the SHA1 asm code ABI conformant by making sure all stack
accesses occur above the stack pointer.

Origin:
http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=1a9d60d2

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/crypto/sha1-armv4-large.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/sha1-armv4-large.S b/arch/arm/crypto/sha1-armv4-large.S
index 92c6eed..99207c4 100644
--- a/arch/arm/crypto/sha1-armv4-large.S
+++ b/arch/arm/crypto/sha1-armv4-large.S
@@ -195,6 +195,7 @@ ENTRY(sha1_block_data_order)
 	add	r3,r3,r10			@ E+=F_00_19(B,C,D)
 	cmp	r14,sp
 	bne	.L_00_15		@ [((11+4)*5+2)*3]
+	sub	sp,sp,#25*4
 #if __ARM_ARCH__<7
 	ldrb	r10,[r1,#2]
 	ldrb	r9,[r1,#3]
@@ -290,7 +291,6 @@ ENTRY(sha1_block_data_order)
 	add	r3,r3,r10			@ E+=F_00_19(B,C,D)
 
 	ldr	r8,.LK_20_39		@ [+15+16*4]
-	sub	sp,sp,#25*4
 	cmn	sp,#0			@ [+3], clear carry to denote 20_39
 .L_20_39_or_60_79:
 	ldr	r9,[r14,#15*4]
-- 
1.8.1.2

