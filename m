Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3JJPtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3JJPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 060/104] ARM: 7837/3: fix Thumb-2 bug in AES assembler code
Date: Thu, 10 Oct 2013 08:41:48 -0700
Message-Id: <1381419752-29733-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 40190c85f427dcfdbab5dbef4ffd2510d649da1f upstream.

Patch 638591c enabled building the AES assembler code in Thumb2 mode.
However, this code used arithmetic involving PC rather than adr{l}
instructions to generate PC-relative references to the lookup tables,
and this needs to take into account the different PC offset when
running in Thumb mode.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/crypto/aes-armv4.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/aes-armv4.S b/arch/arm/crypto/aes-armv4.S
index 19d6cd6..3a14ea8 100644
--- a/arch/arm/crypto/aes-armv4.S
+++ b/arch/arm/crypto/aes-armv4.S
@@ -148,7 +148,7 @@ AES_Te:
 @ 		 const AES_KEY *key) {
 .align	5
 ENTRY(AES_encrypt)
-	sub	r3,pc,#8		@ AES_encrypt
+	adr	r3,AES_encrypt
 	stmdb   sp!,{r1,r4-r12,lr}
 	mov	r12,r0		@ inp
 	mov	r11,r2
@@ -381,7 +381,7 @@ _armv4_AES_encrypt:
 .align	5
 ENTRY(private_AES_set_encrypt_key)
 _armv4_AES_set_encrypt_key:
-	sub	r3,pc,#8		@ AES_set_encrypt_key
+	adr	r3,_armv4_AES_set_encrypt_key
 	teq	r0,#0
 	moveq	r0,#-1
 	beq	.Labrt
@@ -843,7 +843,7 @@ AES_Td:
 @ 		 const AES_KEY *key) {
 .align	5
 ENTRY(AES_decrypt)
-	sub	r3,pc,#8		@ AES_decrypt
+	adr	r3,AES_decrypt
 	stmdb   sp!,{r1,r4-r12,lr}
 	mov	r12,r0		@ inp
 	mov	r11,r2
-- 
1.8.1.2

