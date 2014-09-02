Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaIBLKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:10:05 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48685 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaIBLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:10:02 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: uislib: uisqueue.c: fixed sparse warning of context imbalance
Date: Tue,  2 Sep 2014 16:39:47 +0530
Message-Id: <1409656187-14215-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning : context imbalance in 'do_locked_client_insert'
			 different lock contexts for basic block

spin_unlock_irqrestore is called at a later stage before returning 
from the function if locked is 1.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/uislib/uisqueue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index f52bca1..63dbe7c 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -96,8 +96,6 @@ do_locked_client_insert(struct uisqueue_info *queueinfo,
 		goto Away;
 	ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
 	acquired = 0;
-	spin_unlock_irqrestore(lock, flags);
-	locked = 0;
 
 	queueinfo->packets_sent++;
 
-- 
1.8.1.2

