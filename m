Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab3BMCu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:50:26 -0500
Received: from mout.gmx.net ([212.227.15.18]:57187 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759666Ab3BMCuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:50:24 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19lz2R2pYhli2OtEbvQTQQ8mQ1JZyCMgzJWj81QX/
	LmxSyLoMwzKPwu
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/9] staging/rtl8187se: Remove unused/unnecessary  variables
Date: Wed, 13 Feb 2013 03:54:29 +0100
Message-Id: <1360724074-2445-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
References: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variables priv and ieee are not used and thus can be removed.
The local variable u1bAIFS is not used/read after assignment and thus
can be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 4aca954..1e54ead 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -866,10 +866,7 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 				   WIRELESS_MODE WirelessMode,
 				   PCHANNEL_ACCESS_SETTING ChnlAccessSetting)
 {
-	struct		r8180_priv *priv = ieee80211_priv(dev);
-	struct		ieee80211_device *ieee = priv->ieee80211;
 	AC_CODING	eACI;
-	u8		u1bAIFS;
 
 	/*
 	 *	<RJ_TODO_8185B>
@@ -891,8 +888,6 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 	write_nic_byte(dev, SIFS, ChnlAccessSetting->SIFS_Timer);
 	write_nic_byte(dev, SLOT, ChnlAccessSetting->SlotTimeTimer); /* Rewrited from directly use PlatformEFIOWrite1Byte(), by Annie, 2006-03-29. */
 
-	u1bAIFS = aSifsTime + (2 * ChnlAccessSetting->SlotTimeTimer);
-
 	write_nic_byte(dev, EIFS, ChnlAccessSetting->EIFS_Timer);
 
 	write_nic_byte(dev, AckTimeOutReg, 0x5B); /* <RJ_EXPR_QOS> Suggested by wcchu, it is the default value of EIFS register, 2005.12.08. */
-- 
1.7.8.6

