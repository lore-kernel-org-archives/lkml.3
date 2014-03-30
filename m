Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaC3XxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:53:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681AbaC3Xnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Jeang Daniel" <dyjeong@qca.qualcomm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.912023131@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 137/200] ath9k: Fix ETSI compliance for AR9462 2.0
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -55,7 +55,7 @@ static const u32 ar9462_2p0_baseband_pos
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3039605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c782},
 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
@@ -85,7 +85,7 @@ static const u32 ar9462_2p0_baseband_pos
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
-	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000ae20, 0x000001a6, 0x000001a6, 0x000001aa, 0x000001aa},
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 

