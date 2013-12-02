Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3LBTRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:17:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3LBTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 050/212] rtlwifi: rtl8192se: Fix wrong assignment
Date: Mon,  2 Dec 2013 11:14:01 -0800
Message-Id: <20131202191253.817163975@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Pena <felipensp@gmail.com>

commit 3aef7dde8dcf09e0124f0a2665845a507331972b upstream.

There is a typo in the struct member name on assignment when checking
rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses pwrgroup_ht40
for bound limit and uses pwrgroup_ht20 when assigning instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -265,7 +265,7 @@ static void _rtl92s_get_txpower_writeval
 				    rtlefuse->pwrgroup_ht40
 				    [RF90_PATH_A][chnl - 1]) {
 					pwrdiff_limit[i] =
-					  rtlefuse->pwrgroup_ht20
+					  rtlefuse->pwrgroup_ht40
 					  [RF90_PATH_A][chnl - 1];
 				}
 			} else {


