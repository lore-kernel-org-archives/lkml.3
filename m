Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3HANEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:04:01 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:53375 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3HAND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:03:59 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHdwZi2MQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: check return value of system in hv_kvp_daemon
Date: Thu,  1 Aug 2013 15:03:56 +0200
Message-Id: <1375362236-15661-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_kvp_daemon.c: In function 'main':
hv_kvp_daemon.c:1441:8: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index ba075e5..b96eccc 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1353,7 +1353,11 @@ setval_done:
 	 */
 
 	snprintf(cmd, sizeof(cmd), "%s %s", "hv_set_ifconfig", if_file);
-	system(cmd);
+	if (system(cmd)) {
+		syslog(LOG_ERR, "Failed to execute cmd '%s'; error: %d %s",
+				cmd, errno, strerror(errno));
+		return HV_E_FAIL;
+	}
 	return 0;
 
 setval_error:
