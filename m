Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKCMMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:12:43 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60639 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKCMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:12:39 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Andreas Koensgen <ajk@comnets.uni-bremen.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hamradio: 6pack: remove unnecessary check
Date: Mon,  3 Nov 2014 17:42:29 +0530
Message-Id: <1415016749-6825-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is check for dev is unnecessary, as we are already checking dev
after allocating it via alloc_netdev, and jumping to label: out
if it is NULL.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/net/hamradio/6pack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index c3c4051..daca0de 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -675,8 +675,7 @@ out_free:
 	kfree(xbuff);
 	kfree(rbuff);
 
-	if (dev)
-		free_netdev(dev);
+	free_netdev(dev);
 
 out:
 	return err;
-- 
1.8.1.2

