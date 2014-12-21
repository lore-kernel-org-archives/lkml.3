Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaLURux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 12:50:53 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49768 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLURuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 12:50:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mahati Chamarthy <mahati.chamarthy@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matthew Casey <mdcasey@chabloom.com>, James Cameron <quozl@laptop.org>,
        Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Emil Goode <emilgoode@gmail.com>,
        Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192e: rtllib_rx.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 18:53:37 +0100
Message-Id: <1419184417-10979-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
update_ibss_network() rtllib_SignalStrengthTranslate()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192e/rtllib_rx.c |   35 ----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 1c2014f..418ef13 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -2211,34 +2211,6 @@ int rtllib_parse_info_param(struct rtllib_device *ieee,
 	return 0;
 }
 
-static inline u8 rtllib_SignalStrengthTranslate(u8  CurrSS)
-{
-	u8 RetSS;
-
-	if (CurrSS >= 71 && CurrSS <= 100)
-		RetSS = 90 + ((CurrSS - 70) / 3);
-	else if (CurrSS >= 41 && CurrSS <= 70)
-		RetSS = 78 + ((CurrSS - 40) / 3);
-	else if (CurrSS >= 31 && CurrSS <= 40)
-		RetSS = 66 + (CurrSS - 30);
-	else if (CurrSS >= 21 && CurrSS <= 30)
-		RetSS = 54 + (CurrSS - 20);
-	else if (CurrSS >= 5 && CurrSS <= 20)
-		RetSS = 42 + (((CurrSS - 5) * 2) / 3);
-	else if (CurrSS == 4)
-		RetSS = 36;
-	else if (CurrSS == 3)
-		RetSS = 27;
-	else if (CurrSS == 2)
-		RetSS = 18;
-	else if (CurrSS == 1)
-		RetSS = 9;
-	else
-		RetSS = CurrSS;
-
-	return RetSS;
-}
-
 static long rtllib_translate_todbm(u8 signal_strength_index)
 {
 	long	signal_power;
@@ -2367,13 +2339,6 @@ static inline int is_same_network(struct rtllib_network *src,
 		(dst->capability & WLAN_CAPABILITY_ESS)));
 }
 
-static inline void update_ibss_network(struct rtllib_network *dst,
-				  struct rtllib_network *src)
-{
-	memcpy(&dst->stats, &src->stats, sizeof(struct rtllib_rx_stats));
-	dst->last_scanned = jiffies;
-}
-
 
 static inline void update_network(struct rtllib_network *dst,
 				  struct rtllib_network *src)
-- 
1.7.10.4

