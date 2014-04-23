Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaDWITQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:19:16 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43611 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDWITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:19:12 -0400
Date: Wed, 23 Apr 2014 17:18:42 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rupert@rmuch.net, daeseok.youn@gmail.com, chad@dahc.us,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: silicom: remove redundant pci_get_drvdata() call
Message-ID: <20140423081842.GA7498@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_get_drvdata() and checking NULL for dev are
called twice in while loop in is_bypass_dev().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
This patch has an warning from checkpatch.pl.
checkpatch.pl warning:
WARNING: Too many leading tabs - consider code refactoring

 drivers/staging/silicom/bypasslib/bypass.c |   51 ++++++++++++---------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 09e00da..a58251f 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -149,38 +149,33 @@ static int is_bypass_dev(int if_index)
 
 	while ((pdev = pci_get_class(PCI_CLASS_NETWORK_ETHERNET << 8, pdev))) {
 		dev = pci_get_drvdata(pdev);
-		if (dev != NULL) {
-			dev = pci_get_drvdata(pdev);
-			if ((dev != NULL) && (dev->ifindex == if_index)) {
-				if ((pdev->vendor == SILICOM_VID) &&
-				    (pdev->device >= SILICOM_BP_PID_MIN) &&
-				    (pdev->device <= SILICOM_BP_PID_MAX)) {
-					goto send_cmd;
-				}
+		if ((dev != NULL) && (dev->ifindex == if_index)) {
+			if ((pdev->vendor == SILICOM_VID) &&
+			    (pdev->device >= SILICOM_BP_PID_MIN) &&
+			    (pdev->device <= SILICOM_BP_PID_MAX)) {
+				goto send_cmd;
+			}
 #if defined(BP_VENDOR_SUPPORT) && defined(ETHTOOL_GDRVINFO)
-				else {
-					struct ethtool_drvinfo info;
-					const struct ethtool_ops *ops =
-					    dev->ethtool_ops;
-					int k = 0;
-
-					if (ops->get_drvinfo) {
-						memset(&info, 0, sizeof(info));
-						info.cmd = ETHTOOL_GDRVINFO;
-						ops->get_drvinfo(dev, &info);
-						for (; bp_desc_array[k]; k++)
-							if (!
-							    (strcmp
-							     (bp_desc_array[k],
-							      info.driver)))
-								goto send_cmd;
-
-					}
+			else {
+				struct ethtool_drvinfo info;
+				const struct ethtool_ops *ops =
+					dev->ethtool_ops;
+				int k = 0;
+
+				if (ops->get_drvinfo) {
+					memset(&info, 0, sizeof(info));
+					info.cmd = ETHTOOL_GDRVINFO;
+					ops->get_drvinfo(dev, &info);
+					for (; bp_desc_array[k]; k++)
+						if (!(strcmp(bp_desc_array[k],
+							     info.driver)))
+							goto send_cmd;
 
 				}
-#endif
-				return -1;
+
 			}
+#endif
+			return -1;
 		}
 	}
  send_cmd:
-- 
1.7.4.4

