Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3F1S6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:58:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3F1S57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 075/105] net: phy: fix a bug when verify the EEE support
Date: Fri, 28 Jun 2013 11:51:37 -0700
Message-Id: <1372445527-24414-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>

[ Upstream commit 9a9c56cb34e65000d1f0a4b7553399bfcf7c5a52 ]

The phy_init_eee has to exit with an error when the
local device and its link partner both do not support EEE.
So this patch fixes a problem when verify this.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/phy/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef9ea92..c17f636 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1092,7 +1092,7 @@ int phy_init_eee(struct phy_device *phydev, bool clk_stop_enable)
 		adv = mmd_eee_adv_to_ethtool_adv_t(eee_adv);
 		lp = mmd_eee_adv_to_ethtool_adv_t(eee_lp);
 		idx = phy_find_setting(phydev->speed, phydev->duplex);
-		if ((lp & adv & settings[idx].setting))
+		if (!(lp & adv & settings[idx].setting))
 			goto eee_exit;
 
 		if (clk_stop_enable) {
-- 
1.8.1.2

