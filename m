Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab3BQXI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:08:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45617 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770Ab3BQWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:01 -0500
Message-Id: <20130217225002.491337529@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:08 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Guenter Roeck <linux@roeck-us.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 07/66] rtlwifi: Fix the usage of the wrong variable in usb.c
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0a06ad8e3a1cb5311b7dbafde45410aa1bce9d40 upstream.

In routine _rtl_rx_pre_process(), skb_dequeue() is called to get an skb;
however, the wrong variable name is used in subsequent calls.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index f2ecdeb..1535efd 100644
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
 


