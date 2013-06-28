Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3F1S4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3F1Sz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 102/105] ath9k_htc: Handle IDLE state transition properly
Date: Fri, 28 Jun 2013 11:52:04 -0700
Message-Id: <1372445527-24414-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 075163bbb0f51174359947e1bce84f5edb23f21e upstream.

Make sure that a chip reset is done when IDLE is turned
off - this fixes authentication timeouts.

Reported-by: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9c07a8f..2f34993 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1174,7 +1174,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		mutex_lock(&priv->htc_pm_lock);
 
 		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (priv->ps_idle)
+		if (!priv->ps_idle)
 			chip_reset = true;
 
 		mutex_unlock(&priv->htc_pm_lock);
-- 
1.8.1.2

