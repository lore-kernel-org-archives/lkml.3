Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaFFMpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:45:15 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56428 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFFMpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:45:12 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH 2/4] drivers: sh: Restrict INTC_USERIMASK to SH4A
Date: Fri,  6 Jun 2014 21:44:33 +0900
Message-Id: <39c5abbc54179998bf04368a11c561e19220d7d4.1402058435.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
In-Reply-To: <cover.1402058435.git.horms+renesas@verge.net.au>
References: <cover.1402058435.git.horms+renesas@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

register_intc_userimask() is called from sh4a code only.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> [r8a7779 legacy]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/sh/intc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/sh/intc/Kconfig b/drivers/sh/intc/Kconfig
index f7d9061..60228fa 100644
--- a/drivers/sh/intc/Kconfig
+++ b/drivers/sh/intc/Kconfig
@@ -6,7 +6,7 @@ comment "Interrupt controller options"
 
 config INTC_USERIMASK
 	bool "Userspace interrupt masking support"
-	depends on ARCH_SHMOBILE || (SUPERH && CPU_SH4A) || COMPILE_TEST
+	depends on (SUPERH && CPU_SH4A) || COMPILE_TEST
 	help
 	  This enables support for hardware-assisted userspace hardirq
 	  masking.
-- 
1.8.4

