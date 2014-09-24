Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaIXOtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:49:52 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:50599 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIXOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:49:46 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 10:49:46 EDT
From: Christoph Jaeger <cj@linux.com>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH linux-next] staging: ozwpan: Remove typedefs
Date: Wed, 24 Sep 2014 10:42:18 -0400
Message-Id: <1411569738-12345-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Jaeger <email@christophjaeger.info>

As these typedefs are only used once, there is no real need for them.

Signed-off-by: Christoph Jaeger <email@christophjaeger.info>
---
 drivers/staging/ozwpan/ozproto.h | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 73cc69b..30c2db9 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -29,23 +29,14 @@
 
 /* Application handler functions.
  */
-typedef int (*oz_app_init_fn_t)(void);
-typedef void (*oz_app_term_fn_t)(void);
-typedef int (*oz_app_start_fn_t)(struct oz_pd *pd, int resume);
-typedef void (*oz_app_stop_fn_t)(struct oz_pd *pd, int pause);
-typedef void (*oz_app_rx_fn_t)(struct oz_pd *pd, struct oz_elt *elt);
-typedef int (*oz_app_heartbeat_fn_t)(struct oz_pd *pd);
-typedef void (*oz_app_farewell_fn_t)(struct oz_pd *pd, u8 ep_num,
-			u8 *data, u8 len);
-
 struct oz_app_if {
-	oz_app_init_fn_t	init;
-	oz_app_term_fn_t	term;
-	oz_app_start_fn_t	start;
-	oz_app_stop_fn_t	stop;
-	oz_app_rx_fn_t		rx;
-	oz_app_heartbeat_fn_t	heartbeat;
-	oz_app_farewell_fn_t	farewell;
+	int  (*init)(void);
+	void (*term)(void);
+	int  (*start)(struct oz_pd *pd, int resume);
+	void (*stop)(struct oz_pd *pd, int pause);
+	void (*rx)(struct oz_pd *pd, struct oz_elt *elt);
+	int  (*heartbeat)(struct oz_pd *pd);
+	void (*farewell)(struct oz_pd *pd, u8 ep_num, u8 *data, u8 len);
 };
 
 int oz_protocol_init(char *devs);
-- 
1.9.3

