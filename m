Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaJLSrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:47:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47113 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaJLSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:47:26 -0400
From: Koray Gulcu <koray.gulcu@ozu.edu.tr>
To: gregkh@linuxfoundation.org
Cc: peter.p.waskiewicz.jr@intel.com, antoine@schweitzer-chaput.fr,
        anarey@gmail.com, c@24.io, rickard_strandqvist@spectrumdigital.se,
        teobaluta@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: rtl8192u: Fix sparse warnings of r8182U_core
Date: Sun, 12 Oct 2014 19:46:50 +0100
Message-Id: <1413139611-22074-2-git-send-email-koray.gulcu@ozu.edu.tr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1413139611-22074-1-git-send-email-koray.gulcu@ozu.edu.tr>
References: <1413139611-22074-1-git-send-email-koray.gulcu@ozu.edu.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following endianness warnings found by sparse running with CF=-D__CHECK_ENDIAN__:

drivers/staging/rtl8192u/r8192U_core.c:1794:10: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1794:10:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1794:10:    got int
drivers/staging/rtl8192u/r8192U_core.c:1794:13: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1794:13:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1794:13:    got int
drivers/staging/rtl8192u/r8192U_core.c:1794:16: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1794:16:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1794:16:    got int
drivers/staging/rtl8192u/r8192U_core.c:1794:19: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1794:19:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1794:19:    got int
drivers/staging/rtl8192u/r8192U_core.c:1795:10: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1795:10:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1795:10:    got int
drivers/staging/rtl8192u/r8192U_core.c:1795:13: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1795:13:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1795:13:    got int
drivers/staging/rtl8192u/r8192U_core.c:1795:16: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1795:16:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1795:16:    got int
drivers/staging/rtl8192u/r8192U_core.c:1795:19: warning: incorrect type in initializer (different base types)
drivers/staging/rtl8192u/r8192U_core.c:1795:19:    expected restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1795:19:    got int
drivers/staging/rtl8192u/r8192U_core.c:1838:34: warning: cast from restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1839:34: warning: cast from restricted __le16
drivers/staging/rtl8192u/r8192U_core.c:1840:34: warning: cast from restricted __le16

Signed-off-by: Koray Gulcu <koray.gulcu@ozu.edu.tr>
---
 drivers/staging/rtl8192u/r8192U_core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 929ac29..49b40ea 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1791,8 +1791,8 @@ static void rtl8192_link_change(struct net_device *dev)
 }
 
 static struct ieee80211_qos_parameters def_qos_parameters = {
-	{3, 3, 3, 3},/* cw_min */
-	{7, 7, 7, 7},/* cw_max */
+	{cpu_to_le16(3), cpu_to_le16(3), cpu_to_le16(3), cpu_to_le16(3)},
+	{cpu_to_le16(7), cpu_to_le16(7), cpu_to_le16(7), cpu_to_le16(7)},
 	{2, 2, 2, 2},/* aifs */
 	{0, 0, 0, 0},/* flags */
 	{0, 0, 0, 0} /* tx_op_limit */
@@ -1835,9 +1835,9 @@ static void rtl8192_qos_activate(struct work_struct *work)
 	for (i = 0; i <  QOS_QUEUE_NUM; i++) {
 		//Mode G/A: slotTimeTimer = 9; Mode B: 20
 		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G)) ? 9 : 20) + aSifsTime;
-		u4bAcParam = ((((u32)(qos_parameters->tx_op_limit[i]))<< AC_PARAM_TXOP_LIMIT_OFFSET)|
-			      (((u32)(qos_parameters->cw_max[i]))<< AC_PARAM_ECW_MAX_OFFSET)|
-			      (((u32)(qos_parameters->cw_min[i]))<< AC_PARAM_ECW_MIN_OFFSET)|
+		u4bAcParam = ((((u32)(le16_to_cpu(qos_parameters->tx_op_limit[i]))) << AC_PARAM_TXOP_LIMIT_OFFSET)|
+			      (((u32)(le16_to_cpu(qos_parameters->cw_max[i]))) << AC_PARAM_ECW_MAX_OFFSET)|
+			      (((u32)(le16_to_cpu(qos_parameters->cw_min[i]))) << AC_PARAM_ECW_MIN_OFFSET)|
 			      ((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
 
 		write_nic_dword(dev, WDCAPARA_ADD[i], u4bAcParam);
-- 
1.7.10.4

