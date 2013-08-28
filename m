Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3H1SaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:30:05 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:43256 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3H1SaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:30:04 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: Fix __udelay parentheses
Date: Wed, 28 Aug 2013 20:29:48 +0200
Message-Id: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that usecs is casted to long long, to ensure that the
(usecs * 4295 * HZ) multiplication is 64 bit.

Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
multiplication, with the result casted to 64 bit. This led to some bits
falling off.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/include/asm/delay.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/delay.h b/arch/arc/include/asm/delay.h
index 442ce5d..8d35fe1 100644
--- a/arch/arc/include/asm/delay.h
+++ b/arch/arc/include/asm/delay.h
@@ -56,8 +56,8 @@ static inline void __udelay(unsigned long usecs)
 	/* (long long) cast ensures 64 bit MPY - real or emulated
 	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
 	 */
-	loops = ((long long)(usecs * 4295 * HZ) *
-		 (long long)(loops_per_jiffy)) >> 32;
+	loops = (((long long) usecs) * 4295 * HZ *
+		  (long long) loops_per_jiffy) >> 32;
 
 	__delay(loops);
 }
-- 
1.7.9.5

