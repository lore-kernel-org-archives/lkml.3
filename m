Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3FYTCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:02:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3FYSeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 56/95] net: phy: fix a bug when verify the EEE support
Date: Tue, 25 Jun 2013 11:32:43 -0700
Message-Id: <20130625182159.992144703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>

[ Upstream commit 9a9c56cb34e65000d1f0a4b7553399bfcf7c5a52 ]

The phy_init_eee has to exit with an error when the
local device and its link partner both do not support EEE.
So this patch fixes a problem when verify this.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1092,7 +1092,7 @@ int phy_init_eee(struct phy_device *phyd
 		adv = mmd_eee_adv_to_ethtool_adv_t(eee_adv);
 		lp = mmd_eee_adv_to_ethtool_adv_t(eee_lp);
 		idx = phy_find_setting(phydev->speed, phydev->duplex);
-		if ((lp & adv & settings[idx].setting))
+		if (!(lp & adv & settings[idx].setting))
 			goto eee_exit;
 
 		if (clk_stop_enable) {


