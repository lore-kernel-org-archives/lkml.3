Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967704Ab3HICJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:09:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967694Ab3HIB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avinash Patil <patila@marvell.com>, Stone Piao <piaoyun@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 059/102] mwifiex: fix wrong data rates in P2P client
Date: Thu,  8 Aug 2013 18:57:35 -0700
Message-Id: <20130809015024.052899738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 237b2ac8ac89a6b0120decdd05c7bf4637deb98a upstream.

This patch fixes an issue wherein adhoc rates were being copied
into association request from P2P client.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cfp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -415,7 +415,8 @@ u32 mwifiex_get_supported_rates(struct m
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
+	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		switch (adapter->config_bands) {
 		case BAND_B:
 			dev_dbg(adapter->dev, "info: infra band=%d "


