Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935443AbaBDWVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:21:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787AbaBDVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 049/133] ath9k: Disable cross-band FCC
Date: Tue,  4 Feb 2014 13:07:30 -0800
Message-Id: <20140204210738.421991215@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 1e2f9295f4c657500111514f92a3d3894d0e05b4 upstream.

Fast Channel Change across bands was enabled for
AR9462 recently, but this is causing baseband issues.
Disable it until this feature is tested well. Also,
remove the feature bit for AR9565 since it is
a single-band card and doesn't support this feature.

Reported-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2608,13 +2608,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw
 	    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 
-	/*
-	 * Fast channel change across bands is available
-	 * only for AR9462 and AR9565.
-	 */
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
-		pCap->hw_caps |= ATH9K_HW_CAP_FCC_BAND_SWITCH;
-
 	return 0;
 }
 


