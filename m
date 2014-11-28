Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaK1GNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:13:09 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:60956 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaK1GNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:13:07 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: decompressor: fix a wrong comment
Date: Fri, 28 Nov 2014 15:12:14 +0900
Message-Id: <1417155134-29808-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment does not correspond to the actual code.

When zImage is loaded at a lower *OR* higher address of
the destination of Image, it won't overwrite itself.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 arch/arm/boot/compressed/head.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 68be901..9dff614 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -178,7 +178,7 @@ not_angel:
 
 		/*
 		 * Set up a page table only if it won't overwrite ourself.
-		 * That means r4 < pc && r4 - 16k page directory > &_end.
+		 * That means r4 < pc || r4 - 16k page directory > &_end.
 		 * Given that r4 > &_end is most unfrequent, we add a rough
 		 * additional 1MB of room for a possible appended DTB.
 		 */
-- 
1.9.1

