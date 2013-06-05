Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3FEWLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:11:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab3FEVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 007/127] ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling
Date: Wed,  5 Jun 2013 14:32:54 -0700
Message-Id: <20130605213218.843240675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/crypto/sha1-armv4-large.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


