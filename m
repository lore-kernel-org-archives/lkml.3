Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3LFXTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:19:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab3LFXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Pena <felipensp@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 088/152] rtlwifi: rtl8192se: Fix wrong assignment
Date: Fri,  6 Dec 2013 15:10:12 -0800
Message-Id: <1386371476-2477-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Pena <felipensp@gmail.com>

commit 3aef7dde8dcf09e0124f0a2665845a507331972b upstream.

There is a typo in the struct member name on assignment when checking
rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses pwrgroup_ht40
for bound limit and uses pwrgroup_ht20 when assigning instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 5061f1d..92d38ab 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -265,7 +265,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
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

