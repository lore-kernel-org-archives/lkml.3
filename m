Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3LSMXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:23:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3LSL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 139/208] ath9k: Fix XLNA bias strength
Date: Thu, 19 Dec 2013 11:53:57 +0000
Message-Id: <1387454106-19326-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit a1783a7b0846fc6414483e6caf646db72023fffd upstream.

The EEPROM parameter to determine whether the bias
strength values for XLNA have to be applied is part
of the miscConfiguration field and not featureEnable.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d3ca712..86d203c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4002,7 +4002,7 @@ static void ar9003_hw_xlna_bias_strength_apply(struct ath_hw *ah, bool is2ghz)
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 bias;
 
-	if (!(eep->baseEepHeader.featureEnable & 0x40))
+	if (!(eep->baseEepHeader.miscConfiguration & 0x40))
 		return;
 
 	if (!AR_SREV_9300(ah))
-- 
1.8.3.2

