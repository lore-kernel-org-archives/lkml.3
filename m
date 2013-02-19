Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3BSTOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:14:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab3BSSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Guenter Roeck <linux@roeck-us.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 12/81] rtlwifi: Fix the usage of the wrong variable in usb.c
Date: Tue, 19 Feb 2013 15:48:35 -0300
Message-Id: <1361299784-8830-13-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0a06ad8e3a1cb5311b7dbafde45410aa1bce9d40 upstream.

In routine _rtl_rx_pre_process(), skb_dequeue() is called to get an skb;
however, the wrong variable name is used in subsequent calls.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/rtlwifi/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 8fa144f..17cd028 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -542,8 +542,8 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	WARN_ON(skb_queue_empty(&rx_queue));
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb = skb_dequeue(&rx_queue);
-		_rtl_usb_rx_process_agg(hw, skb);
-		ieee80211_rx_irqsafe(hw, skb);
+		_rtl_usb_rx_process_agg(hw, _skb);
+		ieee80211_rx_irqsafe(hw, _skb);
 	}
 }
 
-- 
1.7.9.5

