Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaDAMWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:22:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaDALQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/144] ath9k: Fix ETSI compliance for AR9462 2.0
Date: Tue,  1 Apr 2014 12:13:36 +0100
Message-Id: <1396350948-29910-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit b3050248c167871ca52cfdb2ce78aa2460249346 upstream.

The minimum CCA power threshold values have to be adjusted
for existing cards to be in compliance with new regulations.
Newer cards will make use of the values obtained from EEPROM,
support for this was added earlier. To make sure that cards
that are already in use and don't have proper values in EEPROM,
do not violate regulations, use the initvals instead.

Reported-by: Jeang Daniel <dyjeong@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 092b9d4..1078fbd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -56,7 +56,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3236605e, 0x32365a5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
@@ -95,7 +95,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
-	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000ae20, 0x000001a6, 0x000001a6, 0x000001aa, 0x000001aa},
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
-- 
1.9.1

