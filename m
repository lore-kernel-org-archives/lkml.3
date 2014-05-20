Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaETVcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:32:06 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54482 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaETVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:32:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: r8192U_core.c:  Fix for possible null pointer dereference
Date: Tue, 20 May 2014 23:32:53 +0200
Message-Id: <1400621573-7672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192u/r8192U_core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1bb6143..7bd58ee 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2038,9 +2038,9 @@ static int WDCAPARA_ADD[] = {EDCAPARA_BE, EDCAPARA_BK, EDCAPARA_VI, EDCAPARA_VO}
 static void rtl8192_qos_activate(struct work_struct *work)
 {
 	struct r8192_priv *priv = container_of(work, struct r8192_priv, qos_activate);
-	struct net_device *dev = priv->ieee80211->dev;
-	struct ieee80211_qos_parameters *qos_parameters = &priv->ieee80211->current_network.qos_data.parameters;
-	u8 mode = priv->ieee80211->current_network.mode;
+	struct net_device *dev;
+	struct ieee80211_qos_parameters *qos_parameters;
+	u8 mode;
 	u8  u1bAIFS;
 	u32 u4bAcParam;
 	int i;
@@ -2048,6 +2048,10 @@ static void rtl8192_qos_activate(struct work_struct *work)
 	if (priv == NULL)
 		return;
 
+	dev = priv->ieee80211->dev;
+	qos_parameters = &priv->ieee80211->current_network.qos_data.parameters;
+	mode = priv->ieee80211->current_network.mode;
+
 	mutex_lock(&priv->mutex);
 	if (priv->ieee80211->state != IEEE80211_LINKED)
 		goto success;
-- 
1.7.10.4

