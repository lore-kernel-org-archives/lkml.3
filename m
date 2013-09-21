Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3IUW2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:28:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49612 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3IUW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:28:31 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: kys@microsoft.com
Cc: haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 02/19] hv: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:34 +0200
Message-Id: <1379802471-30252-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable execute_shutdown is only assigned the values true and
false. Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/hv/hv_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index cb82233..fa37369 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -82,7 +82,7 @@ static void shutdown_onchannelcallback(void *context)
 	struct vmbus_channel *channel = context;
 	u32 recvlen;
 	u64 requestid;
-	u8  execute_shutdown = false;
+	bool  execute_shutdown = false;
 	u8  *shut_txf_buf = util_shutdown.recv_buffer;
 
 	struct shutdown_msg_data *shutdown_msg;
-- 
1.8.3.1

