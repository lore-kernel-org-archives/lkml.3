Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbaBDWaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:30:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933834AbaBDVIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 029/133] rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
Date: Tue,  4 Feb 2014 13:07:10 -0800
Message-Id: <20140204210737.855383777@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8fd77aec1a9d6f4328fc0244f21932114e066df3 upstream.

This driver has a watchdog timer that attempts to reconnect when beacon frames
are not seen for 6 seconds. This patch disables that reconnect whenever the
device has never been connected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1437,7 +1437,8 @@ void rtl_watchdog_wq_callback(void *data
 			/* if we can't recv beacon for 6s, we should
 			 * reconnect this AP
 			 */
-			if (rtlpriv->link_info.roam_times >= 3) {
+			if ((rtlpriv->link_info.roam_times >= 3) &&
+			    !is_zero_ether_addr(rtlpriv->mac80211.bssid)) {
 				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 					 "AP off, try to reconnect now\n");
 				rtlpriv->link_info.roam_times = 0;


