Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaJ1DpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:45:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaJ1DpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.16 064/127] Revert "ath9k_hw: reduce ANI firstep range for older chips"
Date: Tue, 28 Oct 2014 11:34:59 +0800
Message-Id: <20141028033423.659868837@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 171cdab8c78bb169d9693d587e1d02d2dd5a0274 upstream.

This reverts commit 09efc56345be4146ab9fc87a55c837ed5d6ea1ab

I've received reports that this change is decreasing throughput in some
rare conditions on an AR9280 based device

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1004,9 +1004,11 @@ static bool ar5008_hw_ani_control_new(st
 	case ATH9K_ANI_FIRSTEP_LEVEL:{
 		u32 level = param;
 
-		value = level;
+		value = level * 2;
 		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 			      AR_PHY_FIND_SIG_FIRSTEP, value);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG_LOW,
+			      AR_PHY_FIND_SIG_FIRSTEP_LOW, value);
 
 		if (level != aniState->firstepLevel) {
 			ath_dbg(common, ANI,


