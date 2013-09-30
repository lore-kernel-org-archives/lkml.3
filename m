Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab3I3K0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:26:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3I3KMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 059/104] ath9k: avoid accessing MRC registers on single-chain devices
Date: Mon, 30 Sep 2013 11:10:36 +0100
Message-Id: <1380535881-9239-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a1c781bb20ac1e03280e420abd47a99eb8bbdd3b upstream.

They are not implemented, and accessing them might trigger errors

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ac2aa7a..fb919e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -956,6 +956,10 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 		 * is_on == 0 means MRC CCK is OFF (more noise imm)
 		 */
 		bool is_on = param ? 1 : 0;
+
+		if (ah->caps.rx_chainmask == 1)
+			break;
+
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_ENABLE, is_on);
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
-- 
1.8.3.2

