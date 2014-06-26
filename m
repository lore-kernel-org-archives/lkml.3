Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFZUO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:14:58 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:40802
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaFZUO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:14:57 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 16:14:57 EDT
x-originating-ip: 72.167.245.219
From: Yue Zhang <yuezha@microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        olaf@aepfle.de, jasowang@redhat.com, apw@canonical.com
Cc: decui@microsoft.com, huishao@microsoft.com
Subject: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Date: Thu, 26 Jun 2014 14:09:28 -0700
Message-Id: <1403816968-15419-1-git-send-email-yuezha@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yue Zhang <yuezha@microsoft.com>

hv_fcopy_daemon fails to overwrite a file if the target file already
exits.

Add O_TRUNC flag on opening.

Signed-off-by: Yue Zhang <yuezha@microsoft.com>
---
 tools/hv/hv_fcopy_daemon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index fba1c75..01eee6b 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -88,7 +88,8 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
 		}
 	}
 
-	target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC, 0744);
+	target_fd = open(target_fname,
+				O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC, 0744);
 	if (target_fd == -1) {
 		syslog(LOG_INFO, "Open Failed: %s", strerror(errno));
 		goto done;
-- 
1.9.1

