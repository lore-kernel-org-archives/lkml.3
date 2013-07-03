Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab3GCSqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:46:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3GCSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:09 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eDVn_xuLC1IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=12aEO2lLl58A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=3j4BkbkPAAAA:8 a=XeyvjbSx1-ENaJC-gdgA:9 a=Z9puGo2VY4EA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184053.852163593@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: YanBo <dreamfly281@gmail.com>, Johannes Berg <johannes.berg@intel.com>
Subject: [056/141] cfg80211: check wdev->netdev in connection work
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0056-cfg80211-check-wdev-netdev-in-connection-work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c815797663b72e3ac1736f1886538152bc48e4af ]

If a P2P-Device is present and another virtual interface triggers
the connection work, the system crash because it tries to check
if the P2P-Device's netdev (which doesn't exist) is up. Skip any
wdevs that have no netdev to fix this.

Cc: stable@vger.kernel.org
Reported-by: YanBo <dreamfly281@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/wireless/sme.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6f39cb8..1015221 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -222,6 +222,9 @@ void cfg80211_conn_work(struct work_struct *work)
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
-- 
1.7.10.4


