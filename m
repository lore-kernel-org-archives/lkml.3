Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaBGNMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:12:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaBGLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/233] rtlwifi: Increase the RX queue length for USB drivers
Date: Fri,  7 Feb 2014 11:44:29 +0000
Message-Id: <1391773652-25214-51-git-send-email-luis.henriques@canonical.com>
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

commit dc6405712268fe514d3dd89aa936c4397b0871b9 upstream.

The current number of RX buffers queued is 32, which is too small under
heavy load. That number is doubled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index e56778c..0f93614 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -555,7 +555,7 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 }
 
-#define __RX_SKB_MAX_QUEUED	32
+#define __RX_SKB_MAX_QUEUED	64
 
 static void _rtl_rx_work(unsigned long param)
 {
-- 
1.8.3.2

