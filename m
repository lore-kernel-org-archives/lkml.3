Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaFSJba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:31:30 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:13873 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbaFSJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:31:28 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-sh@vger.kernel.org, linux-next@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH linux-next] ARM: shmobile: rcar-gen2: update call to dma_contiguous_reserve_area
Date: Thu, 19 Jun 2014 11:31:10 +0200
Message-Id: <1403170270-17877-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5ea3b1b2f8ad 'cma: add placement specifier for "cma=" kernel parameter'
adds a new 'fixed' parameter to dma_contiguous_reserve_area(). Update
rcar_gen2_reserve() accordingly.

This fixes the following compilation error:

  arch/arm/mach-shmobile/setup-rcar-gen2.c: In function ‘rcar_gen2_reserve’:
  arch/arm/mach-shmobile/setup-rcar-gen2.c:182:10: error: too few arguments to function ‘dma_contiguous_reserve_area’

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
---

Hi,

This can be seen with linux next-20140619 and e.g. arm allmodconfig.

Best regards,

V.

 arch/arm/mach-shmobile/setup-rcar-gen2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c b/arch/arm/mach-shmobile/setup-rcar-gen2.c
index 73fb2a6..42d5b43 100644
--- a/arch/arm/mach-shmobile/setup-rcar-gen2.c
+++ b/arch/arm/mach-shmobile/setup-rcar-gen2.c
@@ -179,6 +179,6 @@ void __init rcar_gen2_reserve(void)
 #ifdef CONFIG_DMA_CMA
 	if (mrc.size)
 		dma_contiguous_reserve_area(mrc.size, mrc.base, 0,
-					    &rcar_gen2_dma_contiguous);
+					    &rcar_gen2_dma_contiguous, true);
 #endif
 }
-- 
2.0.0

