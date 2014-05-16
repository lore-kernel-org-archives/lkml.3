Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaEPIIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:08:54 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47047 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaEPIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:08:47 -0400
Date: Fri, 16 May 2014 17:08:10 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: rupesh.gujare@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ozwpan: remove redundant NULL check for devs
Message-ID: <20140516080810.GA16229@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1cebea7a40490d0d0b122eb444a105d424af42e6 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 16 May 2014 17:02:04 +0900
Subject: [PATCH] staging: ozwpan: remove redundant NULL check for devs

The "devs" is a pointer to g_net_dev in ozmain.c.
g_net_dev has a default value as empty string.
So "devs" cannot be NULL, removes NULL check for "devs".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/ozwpan/ozproto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index f09acd0..767cac4 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -765,7 +765,7 @@ static char *oz_get_next_device_name(char *s, char *dname, int max_size)
 int oz_protocol_init(char *devs)
 {
 	skb_queue_head_init(&g_rx_queue);
-	if (devs && (devs[0] == '*')) {
+	if (devs[0] == '*') {
 		oz_binding_add(NULL);
 	} else {
 		char d[32];
-- 
1.7.1

