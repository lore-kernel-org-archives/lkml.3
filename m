Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbaGDQrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:47:01 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:52790 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699AbaGDQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:47:00 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] m32r: subtract textlen instead of adding in function m32r_flat_get_addr_from_rp
Date: Fri,  4 Jul 2014 12:46:55 -0400
Message-Id: <1404492415-5063-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the message stating in this function to substract textlen for return
value of case FLAT_M32R_LO16_DATA in the switch statement for this function.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m32r/include/asm/flat.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/m32r/include/asm/flat.h b/arch/m32r/include/asm/flat.h
index 5d711c4..12ac950 100644
--- a/arch/m32r/include/asm/flat.h
+++ b/arch/m32r/include/asm/flat.h
@@ -83,10 +83,8 @@ static inline unsigned long m32r_flat_get_addr_from_rp (unsigned long *rp,
 		case FLAT_M32R_LO16:
 			return htonl(*rp) & 0xFFFF;
 		case FLAT_M32R_LO16_DATA:
-                        /* FIXME: The return value will decrease by textlen
-			   at m32r_flat_put_addr_at_rp () */
 			textlen_for_m32r_lo16_data = textlen;
-			return (htonl(*rp) & 0xFFFF) + textlen;
+			return (htonl(*rp) & 0xFFFF) - textlen;
 		case FLAT_M32R_16:
 			return htons(*(unsigned short *)rp) & 0xFFFF;
 		case FLAT_M32R_24:
-- 
1.9.1

