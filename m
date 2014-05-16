Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaEPXo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:44:29 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37849 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaEPXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:44:28 -0400
From: Hani Benhabiles <kroosec@gmail.com>
To: Paul.Clements@steeleye.com
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] nbd: Zero from and len fields in NBD_CMD_DISCONNECT.
Date: Sat, 17 May 2014 00:43:27 +0100
Message-Id: <1400283807-27930-1-git-send-email-kroosec@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len field is already set to zero, but not the from field which is sent as
0xfffffffffffffe00. This makes no sense, and may cause confuse server
implementations doing sanity checks (qemu-nbd is an example.)

Signed-off-by: Hani Benhabiles <hani@linux.com>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3a70ea2..657bdac 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -246,7 +246,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
 
-	if (nbd_cmd(req) == NBD_CMD_FLUSH) {
+	if (nbd_cmd(req) == NBD_CMD_FLUSH || nbd_cmd(req) == NBD_CMD_DISC) {
 		/* Other values are reserved for FLUSH requests.  */
 		request.from = 0;
 		request.len = 0;
-- 
1.8.3.2

