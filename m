Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422729Ab3LTNwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:52:23 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37583 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422681Ab3LTNwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:52:20 -0500
From: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
To: michael.hoefler@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rupert Muchembled <rupert@rmuch.net>, Chad Williamson <chad@dahc.us>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 2/3] silicom: fix coding style issues in bypass.c
Date: Fri, 20 Dec 2013 14:51:12 +0100
Message-Id: <1387547475-7135-3-git-send-email-michael.hoefler@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
References: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves bypass.c (in staging) in terms of coding style. This
includes different issues some of them mentioned by checkpatch:

 - a c++ one line comment
 - parenthesis at return statementes
 - multiple definitions in one line
 - missing braces according to the style guide

Signed-off-by: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Signed-off-by: Christoph Kohl <christoph.kohl@t-online.de>
---
 drivers/staging/silicom/bypasslib/bypass.c | 32 ++++++++++++++++--------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 14721a9..ff0c517 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -22,7 +22,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#include <linux/netdevice.h>	// struct device, and other headers
+#include <linux/netdevice.h>	/* struct device, and other headers */
 #include <linux/kernel_stat.h>
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
@@ -139,7 +139,7 @@ static int is_dev_sd(int if_index)
 {
 	int ret = 0;
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
-	return (ret >= 0 ? 1 : 0);
+	return ret >= 0 ? 1 : 0;
 }
 
 static int is_bypass_dev(int if_index)
@@ -147,7 +147,8 @@ static int is_bypass_dev(int if_index)
 	struct pci_dev *pdev = NULL;
 	struct net_device *dev = NULL;
 	struct ifreq ifr;
-	int ret = 0, data = 0;
+	int ret = 0;
+	int data = 0;
 
 	while ((pdev = pci_get_class(PCI_CLASS_NETWORK_ETHERNET << 8, pdev))) {
 		if ((dev = pci_get_drvdata(pdev)) != NULL)
@@ -155,8 +156,9 @@ static int is_bypass_dev(int if_index)
 			    (dev->ifindex == if_index)) {
 				if ((pdev->vendor == SILICOM_VID) &&
 				    (pdev->device >= SILICOM_BP_PID_MIN) &&
-				    (pdev->device <= SILICOM_BP_PID_MAX))
+				    (pdev->device <= SILICOM_BP_PID_MAX)) {
 					goto send_cmd;
+				}
 #if defined(BP_VENDOR_SUPPORT) && defined(ETHTOOL_GDRVINFO)
 				else {
 					struct ethtool_drvinfo info;
@@ -184,7 +186,7 @@ static int is_bypass_dev(int if_index)
 	}
  send_cmd:
 	ret = do_cmd(dev, &ifr, IS_BYPASS, &data);
-	return (ret < 0 ? -1 : ret);
+	return ret < 0 ? -1 : ret;
 }
 
 static int is_bypass(int if_index)
@@ -275,12 +277,13 @@ EXPORT_SYMBOL(get_bypass_pwup);
 
 static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
-	int data = ms_timeout, ret = 0;
+	int data = ms_timeout;
+	int ret = 0;
 
-	if (is_dev_sd(if_index))
+	if (is_dev_sd(if_index)) {
 		SET_BPLIB_INT_FN3(set_bypass_wd, int, if_index, int, ms_timeout,
 				  int *, ms_timeout_set, ret);
-	else {
+	} else {
 		ret = doit(SET_BYPASS_WD, if_index, &data);
 		if (ret > 0) {
 			*ms_timeout_set = ret;
@@ -293,7 +296,8 @@ EXPORT_SYMBOL(set_bypass_wd);
 
 static int get_bypass_wd(int if_index, int *ms_timeout_set)
 {
-	int *data = ms_timeout_set, ret = 0;
+	int *data = ms_timeout_set;
+	int ret = 0;
 
 	if (is_dev_sd(if_index))
 		SET_BPLIB_INT_FN2(get_bypass_wd, int, if_index, int *,
@@ -308,10 +312,10 @@ static int get_wd_expire_time(int if_index, int *ms_time_left)
 {
 	int *data = ms_time_left, ret = 0;
 
-	if (is_dev_sd(if_index))
+	if (is_dev_sd(if_index)) {
 		SET_BPLIB_INT_FN2(get_wd_expire_time, int, if_index, int *,
 				  ms_time_left, ret);
-	else {
+	} else {
 		ret = doit(GET_WD_EXPIRE_TIME, if_index, data);
 		if ((ret == 0) && (*data != 0))
 			ret = 1;
@@ -505,17 +509,15 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 				bypass_cb->cmd = GET_BYPASS_INFO;
 
 				if (dev->netdev_ops &&
-					dev->netdev_ops->ndo_do_ioctl) {
+					dev->netdev_ops->ndo_do_ioctl)
 					ret = dev->netdev_ops->ndo_do_ioctl(dev,
 						&ifr, SIOCGIFBYPASS);
-				}
-
 				else
 					ret = -1;
 				if (ret == 0)
 					memcpy(bp_info, &bypass_cb->bp_info,
 					       sizeof(struct bp_info));
-				ret = (ret < 0 ? -1 : 0);
+				ret = ret < 0 ? -1 : 0;
 				break;
 			}
 		}
-- 
1.8.1.2

