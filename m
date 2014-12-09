Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaLIPsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757524AbaLIPsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:48:38 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 5/5] Tools: hv: do not add redundant '/' in hv_start_fcopy()
Date: Tue,  9 Dec 2014 16:48:23 +0100
Message-Id: <1418140103-11854-6-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to add additional '/' to smsg->path_name as snprintf("%s/%s")
does the right thing. Without the patch we get doubled '//' in the log message.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_fcopy_daemon.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 1a23872..9445d8f 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -43,12 +43,6 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 	int error = HV_E_FAIL;
 	char *q, *p;
 
-	/*
-	 * If possile append a path seperator to the path.
-	 */
-	if (strlen((char *)smsg->path_name) < (W_MAX_PATH - 2))
-		strcat((char *)smsg->path_name, "/");
-
 	p = (char *)smsg->path_name;
 	snprintf(target_fname, sizeof(target_fname), "%s/%s",
 		 (char *)smsg->path_name, (char *)smsg->file_name);
-- 
1.9.3

