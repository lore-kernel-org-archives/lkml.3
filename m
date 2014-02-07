Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaBGNLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:11:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaBGLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 051/233] rtlwifi: Update beacon statistics for USB driver
Date: Fri,  7 Feb 2014 11:44:30 +0000
Message-Id: <1391773652-25214-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 65b9cc97c6852fae19dc5c7745e9abc8dd380aad upstream.

The USB drivers were not updating the beacon statistics, which led to
false beacon loss indications.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 0f93614..9792474 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -484,6 +484,8 @@ static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
 			if (unicast)
 				rtlpriv->link_info.num_rx_inperiod++;
 		}
+		/* static bcn for roaming */
+		rtl_beacon_statistic(hw, skb);
 	}
 }
 
-- 
1.8.3.2

