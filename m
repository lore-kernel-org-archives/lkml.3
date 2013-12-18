Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3LRWGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:06:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3LRVMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 37/78] ath9k: Fix XLNA bias strength
Date: Wed, 18 Dec 2013 13:11:05 -0800
Message-Id: <20131218211112.953114616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit a1783a7b0846fc6414483e6caf646db72023fffd upstream.

The EEPROM parameter to determine whether the bias
strength values for XLNA have to be applied is part
of the miscConfiguration field and not featureEnable.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3990,7 +3990,7 @@ static void ar9003_hw_xlna_bias_strength
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 bias;
 
-	if (!(eep->baseEepHeader.featureEnable & 0x40))
+	if (!(eep->baseEepHeader.miscConfiguration & 0x40))
 		return;
 
 	if (!AR_SREV_9300(ah))


