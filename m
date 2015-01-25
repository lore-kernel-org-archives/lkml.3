Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbbAYSQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:16:36 -0500
Received: from www.osadl.org ([62.245.132.105]:42046 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbbAYSQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:16:34 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2] net: hyperv: else branch not necessary
Date: Sun, 25 Jan 2015 19:08:37 +0100
Message-Id: <1422209317-18975-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the if completes with a unconditional goto the else branch
is not needed here.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

v2: added missing subsystem string in subject line - patch unchanged

All paths of execution that did not exit through the if branch will 
go through the else branch so no need for an explicit else here

Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, CONFIG_HYPERV_NET=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/net/hyperv/rndis_filter.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 7bd8387..efb84a9 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -833,10 +833,10 @@ int rndis_filter_set_packet_filter(struct rndis_device *dev, u32 new_filter)
 		 * send completion for it.
 		 */
 		goto exit;
-	} else {
-		set_complete = &request->response_msg.msg.set_complete;
-		status = set_complete->status;
-	}
+	} 
+
+	set_complete = &request->response_msg.msg.set_complete;
+	status = set_complete->status;
 
 cleanup:
 	if (request)
-- 
1.7.10.4

