Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbaKNOnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:43:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:53221 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaKNOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:43:07 -0500
From: John Ogness <john.ogness@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net
Cc: mugunthanvnm@ti.com
Cc: balbi@ti.com
Cc: george.cherian@ti.com
Cc: jhovold@gmail.com
Cc: mpa@pengutronix.de
Cc: bhutchings@solarflare.com
Cc: zonque@gmail.com
Cc: tklauser@distanz.ch
Cc: netdev@vger.kernel.org
Subject: [PATCH 1/1] drivers: net: cpsw: Fix TX_IN_SEL offset
Date: Fri, 14 Nov 2014 15:42:52 +0100
Message-ID: <87sihlj11v.fsf@linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TX_IN_SEL offset for the CPSW_PORT/TX_IN_CTL register was
incorrect. This caused the Dual MAC mode to never get set when
it should. It also caused possible unintentional setting of a
bit in the CPSW_PORT/TX_BLKS_REM register.

The purpose of setting the Dual MAC mode for this register is to:

    "... allow packets from both ethernet ports to be written into
     the FIFO without one port starving the other port."
					- AM335x ARM TRM

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/net/ethernet/ti/cpsw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index d879448..c560f9a 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -129,9 +129,9 @@ do {								\
 #define CPSW_VLAN_AWARE		BIT(1)
 #define CPSW_ALE_VLAN_AWARE	1
 
-#define CPSW_FIFO_NORMAL_MODE		(0 << 15)
-#define CPSW_FIFO_DUAL_MAC_MODE		(1 << 15)
-#define CPSW_FIFO_RATE_LIMIT_MODE	(2 << 15)
+#define CPSW_FIFO_NORMAL_MODE		(0 << 16)
+#define CPSW_FIFO_DUAL_MAC_MODE		(1 << 16)
+#define CPSW_FIFO_RATE_LIMIT_MODE	(2 << 16)
 
 #define CPSW_INTPACEEN		(0x3f << 16)
 #define CPSW_INTPRESCALE_MASK	(0x7FF << 0)
-- 
1.7.10.4
