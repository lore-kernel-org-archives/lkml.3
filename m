Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaD0VRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:17:49 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49650 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaD0VRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:47 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 5/5] staging/lustre/lnet: fix potential null pointer dereference
Date: Sun, 27 Apr 2014 17:17:26 -0400
Message-Id: <1398633446-16719-6-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Pointer 'ni' checked for NULL at line 1569 may be passed to
function and may be dereferenced there by passing argument 1 to
function 'lnet_ni_notify_locked' at line 1621.
found by Klocwork Insight tool

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/lnet/router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 995f509..ba0278e 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1559,7 +1559,8 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, cfs_time_t when)
 
 	lnet_notify_locked(lp, ni == NULL, alive, when);
 
-	lnet_ni_notify_locked(ni, lp);
+	if (ni != NULL)
+		lnet_ni_notify_locked(ni, lp);
 
 	lnet_peer_decref_locked(lp);
 
-- 
1.9.0

