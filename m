Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3EVWRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:17:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab3EVWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sukanto Ghosh <sghosh@apm.com>, Anup Patel <anup.patel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 02/21] arm64: mm: Fix operands of clz in __flush_dcache_all
Date: Wed, 22 May 2013 15:10:20 -0700
Message-Id: <20130522205232.901037709@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sukanto Ghosh <sghosh@apm.com>

commit b4fed0796841b5293b9c9427a5391b7bb20ef2d9 upstream.

The format of the lower 32-bits of the 64-bit operand to 'dc cisw' is
unchanged from ARMv7 architecture and the upper bits are RES0. This
implies that the 'way' field of the operand of 'dc cisw' occupies the
bit-positions [31 .. (32-A)]. Due to the use of 64-bit extended operands
to 'clz', the existing implementation of __flush_dcache_all is incorrectly
placing the 'way' field in the bit-positions [63 .. (64-A)].

Signed-off-by: Sukanto Ghosh <sghosh@apm.com>
Tested-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/cache.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -52,7 +52,7 @@ loop1:
 	add	x2, x2, #4			// add 4 (line length offset)
 	mov	x4, #0x3ff
 	and	x4, x4, x1, lsr #3		// find maximum number on the way size
-	clz	x5, x4				// find bit position of way size increment
+	clz	w5, w4				// find bit position of way size increment
 	mov	x7, #0x7fff
 	and	x7, x7, x1, lsr #13		// extract max number of the index size
 loop2:


