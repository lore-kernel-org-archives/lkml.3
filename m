Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaBGNMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:12:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaBGLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/233] rtlwifi: Set the link state
Date: Fri,  7 Feb 2014 11:44:27 +0000
Message-Id: <1391773652-25214-49-git-send-email-luis.henriques@canonical.com>
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

commit 619ce76f8bb850b57032501a39f26aa6c6731c70 upstream.

The present code fails to set the linked state when an interface is
added.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 0f12cd3..3550e8a 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -194,6 +194,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 					rtlpriv->cfg->maps
 					[RTL_IBSS_INT_MASKS]);
 		}
+		mac->link_state = MAC80211_LINKED;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
-- 
1.8.3.2

