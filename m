Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3HMR3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:29:55 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:53308 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3HMR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:53 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 06/10] staging: ozwpan: Make oz_hcd_pd_arrived() return a struct pointer
Date: Tue, 13 Aug 2013 18:29:22 +0100
Message-ID: <1376414966-23525-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oz_hcd_pd_arrived returns struct oz_port *, change function
declaration to avoid ambiguity.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    4 ++--
 drivers/staging/ozwpan/ozhcd.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 8633f0c..73d80f2 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -660,10 +660,10 @@ static inline void oz_hcd_put(struct oz_hcd *ozhcd)
  * probably very rare indeed.
  * Context: softirq
  */
-void *oz_hcd_pd_arrived(void *hpd)
+struct oz_port *oz_hcd_pd_arrived(void *hpd)
 {
 	int i;
-	void *hport = NULL;
+	struct oz_port *hport = NULL;
 	struct oz_hcd *ozhcd = NULL;
 	struct oz_endpoint *ep;
 
diff --git a/drivers/staging/ozwpan/ozhcd.h b/drivers/staging/ozwpan/ozhcd.h
index 9b30dfd..ef3202f 100644
--- a/drivers/staging/ozwpan/ozhcd.h
+++ b/drivers/staging/ozwpan/ozhcd.h
@@ -7,8 +7,8 @@
 
 int oz_hcd_init(void);
 void oz_hcd_term(void);
-void *oz_hcd_pd_arrived(void *ctx);
 void oz_hcd_pd_departed(void *ctx);
+struct oz_port *oz_hcd_pd_arrived(void *ctx);
 void oz_hcd_pd_reset(void *hpd, void *hport);
 
 #endif /* _OZHCD_H */
-- 
1.7.9.5

