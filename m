Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967608Ab3DRJjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:39:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab3DRJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stone Piao <piaoyun@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 07/72] mwifiex: limit channel number not to overflow memory
Date: Thu, 18 Apr 2013 10:15:52 +0100
Message-Id: <1366276617-3553-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stone Piao <piaoyun@marvell.com>

commit 901ceba4e81e9dd6b4a3c4c37ee22000a6c5c65f upstream.

Limit the channel number in scan request, or the driver scan
config structure memory will be overflowed.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 76b5c0f..4506cda 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1368,7 +1368,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
-	for (i = 0; i < request->n_channels; i++) {
+	for (i = 0; i < min_t(u32, request->n_channels,
+			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
-- 
1.8.1.2

