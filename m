Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaCEO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:57:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaCEOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Langlois <olivier@trillion01.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 10/62] rtlwifi: Fix incorrect return from rtl_ps_enable_nic()
Date: Wed,  5 Mar 2014 14:36:14 +0000
Message-Id: <1394030226-26652-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Langlois <olivier@trillion01.com>

commit 2e8c5e56b307271c2dab6f8bfd1d8a3822ca2390 upstream.

rtl_ps_enable_nic() is called from loops that will loop until this function returns true or a
maximum number of retries is performed.

hw_init() returns non-zero on error. In that situation return false to
restore the original design intent to retry hw init when it fails.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 5ae2664..18bd09a 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -48,7 +48,7 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 
 	/*<2> Enable Adapter */
 	if (rtlpriv->cfg->ops->hw_init(hw))
-		return 1;
+		return false;
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
-- 
1.9.0

