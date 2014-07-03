Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaGCBxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:53:24 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:53754 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaGCBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:53:22 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] M32Rz: FIXME add textlen in function m32r_flat_get_addr_from_rp
Date: Wed,  2 Jul 2014 21:53:15 -0400
Message-Id: <1404352395-5854-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds textlen in this function for case FLAT_M32R_LO16_DATA
in the return statement verus subtracting it in order to fix this
FIXME message.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/m32r/include/asm/flat.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/m32r/include/asm/flat.h b/arch/m32r/include/asm/flat.h
index 5d711c4..8f0141f 100644
--- a/arch/m32r/include/asm/flat.h
+++ b/arch/m32r/include/asm/flat.h
@@ -83,8 +83,6 @@ static inline unsigned long m32r_flat_get_addr_from_rp (unsigned long *rp,
 		case FLAT_M32R_LO16:
 			return htonl(*rp) & 0xFFFF;
 		case FLAT_M32R_LO16_DATA:
-                        /* FIXME: The return value will decrease by textlen
-			   at m32r_flat_put_addr_at_rp () */
 			textlen_for_m32r_lo16_data = textlen;
 			return (htonl(*rp) & 0xFFFF) + textlen;
 		case FLAT_M32R_16:
-- 
1.9.1

