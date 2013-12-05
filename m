Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab3LERh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab3LERhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Pena <felipensp@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 42/90] rtlwifi: rtl8192se: Fix wrong assignment
Date: Thu,  5 Dec 2013 17:35:24 +0000
Message-Id: <1386264972-5399-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Pena <felipensp@gmail.com>

commit 3aef7dde8dcf09e0124f0a2665845a507331972b upstream.

There is a typo in the struct member name on assignment when checking
rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses pwrgroup_ht40
for bound limit and uses pwrgroup_ht20 when assigning instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 08c2f56..c405f96 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -268,7 +268,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
 				    rtlefuse->pwrgroup_ht40
 				    [RF90_PATH_A][chnl - 1]) {
 					pwrdiff_limit[i] =
-					  rtlefuse->pwrgroup_ht20
+					  rtlefuse->pwrgroup_ht40
 					  [RF90_PATH_A][chnl - 1];
 				}
 			} else {
-- 
1.8.3.2

