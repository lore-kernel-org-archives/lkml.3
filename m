Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaFYMUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:20:00 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60334 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbaFYMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:19:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ana Rey <anarey@gmail.com>, Andrea Merello <andrea.merello@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>, Chi Pham <fempsci@gmail.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: r8192U_core.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 14:20:58 +0200
Message-Id: <1403698858-22513-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A struct member variable is set to the same value more than once

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192u/r8192U_core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 24272c5..b2b4cd0 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2355,7 +2355,6 @@ static void rtl8192_init_priv_variable(struct net_device *dev)
 
 	priv->ieee80211->FwRWRF = 0;	//we don't use FW read/write RF until stable firmware is available.
 	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
-	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
 		IEEE_SOFTMAC_ASSOCIATE | IEEE_SOFTMAC_PROBERQ |
 		IEEE_SOFTMAC_PROBERS | IEEE_SOFTMAC_TX_QUEUE |
-- 
1.7.10.4

