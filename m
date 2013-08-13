Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3HMQBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:01:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab3HMP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:38 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jKd_vbfP5QMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=V-DKYl99U3kA:10 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155830.350819618@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ignacy Gawedzki <i@lri.fr>, Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [43/88] ath9k_htc: Handle IDLE state transition properly
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0043-ath9k_htc-Handle-IDLE-state-transition-properly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[ Upstream commit 075163bbb0f51174359947e1bce84f5edb23f21e ]

Make sure that a chip reset is done when IDLE is turned
off - this fixes authentication timeouts.

Cc: stable@vger.kernel.org
Reported-by: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c785129..b132b43 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1193,7 +1193,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		mutex_lock(&priv->htc_pm_lock);
 
 		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (priv->ps_idle)
+		if (!priv->ps_idle)
 			chip_reset = true;
 
 		mutex_unlock(&priv->htc_pm_lock);
-- 
1.7.10.4


