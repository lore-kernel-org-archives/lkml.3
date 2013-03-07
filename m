Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3CGMMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:12:53 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49724 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] TTY: synclink, remove superfluous check
Date: Thu,  7 Mar 2013 13:12:26 +0100
Message-Id: <1362658360-26629-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

info is obtained by container_of. It can never be NULL. So do not test
that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/synclink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 8983276..72d6071 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1058,9 +1058,6 @@ static void mgsl_bh_handler(struct work_struct *work)
 		container_of(work, struct mgsl_struct, task);
 	int action;
 
-	if (!info)
-		return;
-		
 	if ( debug_level >= DEBUG_LEVEL_BH )
 		printk( "%s(%d):mgsl_bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
-- 
1.8.1.4


