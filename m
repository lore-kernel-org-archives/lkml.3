Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3HARk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:40:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47383 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3HARk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:40:26 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/6] staging: ozwpan: Mark string as const
Date: Thu, 1 Aug 2013 18:40:01 +0100
Message-ID: <1375378806-17948-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we mark const string so that it does not get modified.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.c |    6 +++---
 drivers/staging/ozwpan/ozproto.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 500800f..2dbaba6 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -636,7 +636,7 @@ static int oz_pkt_recv(struct sk_buff *skb, struct net_device *dev,
 /*------------------------------------------------------------------------------
  * Context: process
  */
-void oz_binding_add(char *net_dev)
+void oz_binding_add(const char *net_dev)
 {
 	struct oz_binding *binding;
 
@@ -669,7 +669,7 @@ void oz_binding_add(char *net_dev)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-static int compare_binding_name(char *s1, char *s2)
+static int compare_binding_name(const char *s1, const char *s2)
 {
 	int i;
 	for (i = 0; i < OZ_MAX_BINDING_LEN; i++) {
@@ -707,7 +707,7 @@ static void pd_stop_all_for_device(struct net_device *net_dev)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-void oz_binding_remove(char *net_dev)
+void oz_binding_remove(const char *net_dev)
 {
 	struct oz_binding *binding;
 	int found = 0;
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 305c532..e532347 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -54,8 +54,8 @@ void oz_protocol_term(void);
 int oz_get_pd_list(struct oz_mac_addr *addr, int max_count);
 void oz_app_enable(int app_id, int enable);
 struct oz_pd *oz_pd_find(const u8 *mac_addr);
-void oz_binding_add(char *net_dev);
-void oz_binding_remove(char *net_dev);
+void oz_binding_add(const char *net_dev);
+void oz_binding_remove(const char *net_dev);
 void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time);
 void oz_timer_delete(struct oz_pd *pd, int type);
 void oz_pd_request_heartbeat(struct oz_pd *pd);
-- 
1.7.9.5

