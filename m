Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3HAMnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:43:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:35866 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3HAMnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:43:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHdwZi2MQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: check return value of daemon to fix compiler warning.
Date: Thu,  1 Aug 2013 14:43:12 +0200
Message-Id: <1375360992-12865-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_kvp_daemon.c: In function 'main':
hv_kvp_daemon.c:1441:8: warning: ignoring return value of 'daemon', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 657c1d2..418ac55 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1439,7 +1439,8 @@ int main(void)
 	char *kvp_recv_buffer;
 	size_t kvp_recv_buffer_len;
 
-	daemon(1, 0);
+	if (daemon(1, 0))
+		return 1;
 	openlog("KVP", 0, LOG_USER);
 	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
 
