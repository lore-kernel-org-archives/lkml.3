Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3BANLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:11:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:44981 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab3BANLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 43/89] ath9k: allow setting arbitrary antenna masks on AR9003+
Date: Fri,  1 Feb 2013 14:07:58 +0100
Message-Id: <20130201130210.597332440@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit fea92cbf0850d788683827990670d3968f893327 upstream.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1830,6 +1830,9 @@ static u32 fill_chainmask(u32 cap, u32 n
 
 static bool validate_antenna_mask(struct ath_hw *ah, u32 val)
 {
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		return true;
+
 	switch (val & 0x7) {
 	case 0x1:
 	case 0x3:


