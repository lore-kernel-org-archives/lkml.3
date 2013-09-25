Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab3IYB06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:26:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab3IYAMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 21/40] ath9k: avoid accessing MRC registers on single-chain devices
Date: Tue, 24 Sep 2013 17:11:53 -0700
Message-Id: <20130925001044.264596189@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a1c781bb20ac1e03280e420abd47a99eb8bbdd3b upstream.

They are not implemented, and accessing them might trigger errors

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1030,6 +1030,10 @@ static bool ar9003_hw_ani_control(struct
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


