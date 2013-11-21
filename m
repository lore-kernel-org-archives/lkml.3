Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3KUOnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:43:01 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39148 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:00 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/2] staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic
Date: Thu, 21 Nov 2013 22:42:45 +0800
Message-Id: <1385044966-3572-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was introduced due to a patch hunk when porting
commit 20802057 (staging/lustre/ptlrpc: race in pinger).

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/pinger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 1707e61..4684b03 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -410,8 +410,8 @@ int ptlrpc_stop_pinger(void)
 	struct l_wait_info lwi = { 0 };
 	int rc = 0;
 
-	if (!thread_is_init(&pinger_thread) &&
-	    !thread_is_stopped(&pinger_thread))
+	if (thread_is_init(&pinger_thread) ||
+	    thread_is_stopped(&pinger_thread))
 		return -EALREADY;
 
 	ptlrpc_pinger_remove_timeouts();
-- 
1.7.9.5

