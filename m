Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaLCLob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:44:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbaLCL1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/101] Input: altera_ps2 - write to correct register when disabling interrupts
Date: Wed,  3 Dec 2014 12:26:36 +0100
Message-Id: <937d4c93ad018deb95c363ed469ed3b228e6e24e.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d0269b8475020718afd7f559064698f5500fa879 upstream.

In altera_ps2_close, the data register (offset 0) is written instead of
the control register (offset 4), leading to the RX interrupt not being
disabled. Fix this by calling writel() with the offset for the proper
register.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/serio/altera_ps2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 4777a73cd390..b6d370ba408f 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -75,7 +75,7 @@ static void altera_ps2_close(struct serio *io)
 {
 	struct ps2if *ps2if = io->port_data;
 
-	writel(0, ps2if->base); /* disable rx irq */
+	writel(0, ps2if->base + 4); /* disable rx irq */
 }
 
 /*
-- 
2.1.3

