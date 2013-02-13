Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab3BMCwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:52:18 -0500
Received: from mout.gmx.net ([212.227.15.19]:55008 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759674Ab3BMCuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:50:21 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/sLTUhhlLsCWKAM33EDoa0RMZsZuFpq1o/vAErph
	SPS1Ht2/iCVqhu
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/9] staging/rtl8187se: Remove code without effect
Date: Wed, 13 Feb 2013 03:54:28 +0100
Message-Id: <1360724074-2445-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
References: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable AcParam is only assigned to but not read/used
afterwards, thus it and all related code can be removed.

The bFollowLegacySetting variable and check can also be removed as it is
always true.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   35 +-----------------------------
 1 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 5495d1e..4aca954 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -869,8 +869,6 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 	struct		r8180_priv *priv = ieee80211_priv(dev);
 	struct		ieee80211_device *ieee = priv->ieee80211;
 	AC_CODING	eACI;
-	AC_PARAM	AcParam;
-	u8		bFollowLegacySetting = 0;
 	u8		u1bAIFS;
 
 	/*
@@ -899,37 +897,8 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 
 	write_nic_byte(dev, AckTimeOutReg, 0x5B); /* <RJ_EXPR_QOS> Suggested by wcchu, it is the default value of EIFS register, 2005.12.08. */
 
-	{ /* Legacy 802.11. */
-		bFollowLegacySetting = 1;
-
-	}
-
-	/* this setting is copied from rtl8187B.  xiong-2006-11-13 */
-	if (bFollowLegacySetting) {
-
-		/*
-		 *	Follow 802.11 seeting to AC parameter, all AC shall use the same parameter.
-		 *	2005.12.01, by rcnjko.
-		 */
-		AcParam.longData = 0;
-		AcParam.f.AciAifsn.f.AIFSN = 2; /* Follow 802.11 DIFS.	*/
-		AcParam.f.AciAifsn.f.ACM = 0;
-		AcParam.f.Ecw.f.ECWmin = ChnlAccessSetting->CWminIndex; /* Follow 802.11 CWmin. */
-		AcParam.f.Ecw.f.ECWmax = ChnlAccessSetting->CWmaxIndex; /* Follow 802.11 CWmax. */
-		AcParam.f.TXOPLimit = 0;
-
-		/* lzm reserved 080826 */
-		/* For turbo mode setting. port from 87B by Isaiah 2008-08-01 */
-		if (ieee->current_network.Turbo_Enable == 1)
-			AcParam.f.TXOPLimit = 0x01FF;
-		/* For 87SE with Intel 4965  Ad-Hoc mode have poor throughput (19MB) */
-		if (ieee->iw_mode == IW_MODE_ADHOC)
-			AcParam.f.TXOPLimit = 0x0020;
-
-		for (eACI = 0; eACI < AC_MAX; eACI++) {
-			AcParam.f.AciAifsn.f.ACI = (u8)eACI;
-			write_nic_byte(dev, ACM_CONTROL, 0);
-		}
+	for (eACI = 0; eACI < AC_MAX; eACI++) {
+		write_nic_byte(dev, ACM_CONTROL, 0);
 	}
 }
 
-- 
1.7.8.6

