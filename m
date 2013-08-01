Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3HANOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:14:49 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:60191 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3HANOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:14:48 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHdwZi2MQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: log errors to syslog in kvp_set_ip_info
Date: Thu,  1 Aug 2013 15:14:44 +0200
Message-Id: <1375362884-15841-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index b96eccc..6a31ca0 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1361,7 +1361,8 @@ setval_done:
 	return 0;
 
 setval_error:
-	syslog(LOG_ERR, "Failed to write config file");
+	syslog(LOG_ERR, "Failed to write config file. error: %d %s",
+		errno, strerror(errno));
 	fclose(file);
 	return error;
 }
