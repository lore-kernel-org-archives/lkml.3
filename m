Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbaFQUFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:05:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53846 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbaFQUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:05:39 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 2/2] tmon: set umask to a reasonable value
Date: Tue, 17 Jun 2014 16:05:09 -0400
Message-Id: <1403035509-31815-3-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
References: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current, the tmon umask value is set to 0, which mean whatever the permission
mask in the shell are when starting tmon in daemon mode are what the permissions
of any created files will be.  We should likely set something more explicit, so
lets go with the usual 022

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Zhang Rui <rui.zhang@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 tools/thermal/tmon/tmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 059e0be..09b7c32 100644
--- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -355,7 +355,7 @@ static void start_daemon_mode()
 	disable_tui();
 
 	/* change the file mode mask */
-	umask(0);
+	umask(S_IWGRP | S_IWOTH);
 
 	/* new SID for the daemon process */
 	sid = setsid();
-- 
1.8.3.1

