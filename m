Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3HOLAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:00:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:58158 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab3HOLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:00:40 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] staging: ozwpan: Remove extra variable.
Date: Thu, 15 Aug 2013 12:00:22 +0100
Message-ID: <1376564422-8749-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376564422-8749-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376564422-8749-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not use extra variable just to copy pointer value,
renaming parameter name serves pupose & removes extra variable.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 9a374fd..2b67107 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -720,9 +720,8 @@ err_put:
  * polled. We release the reference we hold on the PD.
  * Context: softirq
  */
-void oz_hcd_pd_departed(struct oz_port *hport)
+void oz_hcd_pd_departed(struct oz_port *port)
 {
-	struct oz_port *port = hport;
 	struct oz_hcd *ozhcd;
 	void *hpd;
 	struct oz_endpoint *ep = NULL;
-- 
1.7.9.5

