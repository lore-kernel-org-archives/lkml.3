Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaG3NEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:04:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:37322 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbaG3ND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:03:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] tty: n_gsm, use setup_timer
Date: Wed, 30 Jul 2014 15:03:57 +0200
Message-Id: <1406725437-24950-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a simple cleanup of init_timer with setting the fields manually.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_gsm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f2d3e2c7d5e8..04633c57d959 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2088,9 +2088,7 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	int i = 0;
 
-	init_timer(&gsm->t2_timer);
-	gsm->t2_timer.function = gsm_control_retransmit;
-	gsm->t2_timer.data = (unsigned long)gsm;
+	setup_timer(&gsm->t2_timer, gsm_control_retransmit, (unsigned long)gsm);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
 	spin_lock_init(&gsm->tx_lock);
-- 
2.0.1

