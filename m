Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937669Ab3DJWvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:51:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937447Ab3DJWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Marco Cesarano <marco@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [ 18/19] Revert "mwifiex: cancel cmd timer and free curr_cmd in shutdown process
Date: Wed, 10 Apr 2013 15:50:41 -0700
Message-Id: <20130410225028.687898651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

revert commit b9f1f48ce20a1b923429c216669d03b5a900a8cf which is commit
084c7189acb3f969c855536166042e27f5dd703f upstream.

It shouldn't have been applied to the 3.0-stable tree.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Marco Cesarano <marco@marvell.com>
Reported-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/init.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -561,14 +561,6 @@ mwifiex_shutdown_drv(struct mwifiex_adap
 		return ret;
 	}
 
-	/* cancel current command */
-	if (adapter->curr_cmd) {
-		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
-		del_timer(&adapter->cmd_timer);
-		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
-		adapter->curr_cmd = NULL;
-	}
-
 	/* shut down mwifiex */
 	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
 


