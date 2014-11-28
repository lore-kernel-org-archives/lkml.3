Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbaK1GLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:11:52 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:60692 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaK1GLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:11:51 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: replace magic number with PAGE_SHIFT macro in fixup_pv code
Date: Fri, 28 Nov 2014 15:10:41 +0900
Message-Id: <1417155041-29735-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This line converts PHYS_OFFSET into PHYS_PFN_OFFSET.
It is better to use PAGE_SHIFT rather than the magic number 12.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 arch/arm/kernel/head.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 664eee8..ecb7be8 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -586,7 +586,7 @@ __fixup_pv_table:
 	add	r5, r5, r3	@ adjust table end address
 	add	r6, r6, r3	@ adjust __pv_phys_pfn_offset address
 	add	r7, r7, r3	@ adjust __pv_offset address
-	mov	r0, r8, lsr #12	@ convert to PFN
+	mov	r0, r8, lsr #PAGE_SHIFT	@ convert to PFN
 	str	r0, [r6]	@ save computed PHYS_OFFSET to __pv_phys_pfn_offset
 	strcc	ip, [r7, #HIGH_OFFSET]	@ save to __pv_offset high bits
 	mov	r6, r3, lsr #24	@ constant for add/sub instructions
-- 
1.9.1

