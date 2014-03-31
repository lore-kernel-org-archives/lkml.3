Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaCaNxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:53:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCaNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 06/71] ath9k: Fix ETSI compliance for AR9462 2.0
Date: Mon, 31 Mar 2014 14:22:12 +0100
Message-Id: <1396272197-13394-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
index 1d6658e..9c7eaa6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -55,7 +55,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
@@ -94,7 +94,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
-	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000ae20, 0x000001a6, 0x000001a6, 0x000001aa, 0x000001aa},
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
-- 
1.9.1

