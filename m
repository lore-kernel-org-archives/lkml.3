Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3JCESe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:18:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3JCES3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 23/57] ARM: 7837/3: fix Thumb-2 bug in AES assembler code
Date: Wed,  2 Oct 2013 21:08:49 -0700
Message-Id: <20131003040638.194800808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/crypto/aes-armv4.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


