Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3GAUKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3GAUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ignacy Gawedzki <i@lri.fr>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 08/26] ath9k_htc: Handle IDLE state transition properly
Date: Mon,  1 Jul 2013 13:10:03 -0700
Message-Id: <20130701200730.837121135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 075163bbb0f51174359947e1bce84f5edb23f21e upstream.

Make sure that a chip reset is done when IDLE is turned
off - this fixes authentication timeouts.

Reported-by: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1174,7 +1174,7 @@ static int ath9k_htc_config(struct ieee8
 		mutex_lock(&priv->htc_pm_lock);
 
 		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (priv->ps_idle)
+		if (!priv->ps_idle)
 			chip_reset = true;
 
 		mutex_unlock(&priv->htc_pm_lock);


