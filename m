Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbbAJFHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:07:22 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:41344
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbAJFGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:49 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 5/5] Tools: hv: do not add redundant '/' in hv_start_fcopy()
Date: Fri,  9 Jan 2015 22:18:55 -0800
Message-Id: <1420870735-2265-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420870735-2265-1-git-send-email-kys@microsoft.com>
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
 <1420870735-2265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

We don't need to add additional '/' to smsg->path_name as snprintf("%s/%s")
does the right thing. Without the patch we get doubled '//' in the log message.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_fcopy_daemon.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

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
1.7.4.1

