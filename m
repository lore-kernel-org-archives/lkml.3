Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3HAM6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:58:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:11128 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3HAM6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:58:16 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHdwZi2MQ==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: in kvp_set_ip_info free mac_addr right after usage
Date: Thu,  1 Aug 2013 14:58:10 +0200
Message-Id: <1375361890-15339-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to simplify error path in upcoming changes.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 418ac55..ba075e5 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1299,6 +1299,7 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	}
 
 	error = kvp_write_file(file, "HWADDR", "", mac_addr);
+	free(mac_addr);
 	if (error)
 		goto setval_error;
 
@@ -1344,7 +1345,6 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 		goto setval_error;
 
 setval_done:
-	free(mac_addr);
 	fclose(file);
 
 	/*
@@ -1358,7 +1358,6 @@ setval_done:
 
 setval_error:
 	syslog(LOG_ERR, "Failed to write config file");
-	free(mac_addr);
 	fclose(file);
 	return error;
 }
