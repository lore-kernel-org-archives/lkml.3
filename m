Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3BLUfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3BLUfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 01/61] rtlwifi: Fix the usage of the wrong variable in usb.c
Date: Tue, 12 Feb 2013 12:34:21 -0800
Message-Id: <20130212203418.133788056@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0a06ad8e3a1cb5311b7dbafde45410aa1bce9d40 upstream.

In routine _rtl_rx_pre_process(), skb_dequeue() is called to get an skb;
however, the wrong variable name is used in subsequent calls.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -542,8 +542,8 @@ static void _rtl_rx_pre_process(struct i
 	WARN_ON(skb_queue_empty(&rx_queue));
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb = skb_dequeue(&rx_queue);
-		_rtl_usb_rx_process_agg(hw, skb);
-		ieee80211_rx_irqsafe(hw, skb);
+		_rtl_usb_rx_process_agg(hw, _skb);
+		ieee80211_rx_irqsafe(hw, _skb);
 	}
 }
 


