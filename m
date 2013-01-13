Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AMRzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:55:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242Ab3AMRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:25 -0500
Message-Id: <20130113174258.324392745@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 12/49] ath9k_hw: Fix RX gain initvals for AR9485
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit a796a1dd5da9645ad77aa687d1a890ecd63ab5a6 upstream.

Populate iniModesRxGain with the correct initvals
array for AR9485 v1.1

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - Adjust context
 - INIT_INI_ARRAY takes additional size and columns arguments]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -701,8 +701,8 @@ static void ar9003_rx_gain_table_mode0(s
 				2);
 	else if (AR_SREV_9485_11(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,
-				ar9485Common_wo_xlna_rx_gain_1_1,
-				ARRAY_SIZE(ar9485Common_wo_xlna_rx_gain_1_1),
+			       ar9485_common_rx_gain_1_1,
+			       ARRAY_SIZE(ar9485_common_rx_gain_1_1),
 				2);
 	else if (AR_SREV_9580(ah))
 		INIT_INI_ARRAY(&ah->iniModesRxGain,


