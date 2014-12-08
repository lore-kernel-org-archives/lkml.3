Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaLHRpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:45:41 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59291 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbaLHRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:45:40 -0500
From: Robert Yang <hachyang@gmail.com>
To: Wim Van Seroeck <wim@iguana.be>, <linux-watchdog@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, ryang <ryang@hach.com>
Subject: [PATCH 1/1] Watchdog: Fixed the watchdog close/stop logic - only close the watchdog if the magic character was received and the magic close is supported.
Date: Mon,  8 Dec 2014 10:45:11 -0700
Message-Id: <1418060711-47872-1-git-send-email-hachyang@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ryang <ryang@hach.com>

Signed-off-by: ryang <ryang@hach.com>
---
 drivers/watchdog/watchdog_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 6aaefba..73793d8 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -471,8 +471,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	 */
 	if (!test_bit(WDOG_ACTIVE, &wdd->status))
 		err = 0;
-	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-		 !(wdd->info->options & WDIOF_MAGICCLOSE))
+	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) &&
+		(wdd->info->options & WDIOF_MAGICCLOSE))
 		err = watchdog_stop(wdd);
 
 	/* If the watchdog was not stopped, send a keepalive ping */
-- 
1.9.1

