Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab3FRQ3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:29:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab3FRQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:47 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>, rmanohar@qca.qualcomm.com
Subject: [ 15/48] Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"
Date: Tue, 18 Jun 2013 09:17:41 -0700
Message-Id: <20130618161728.094935264@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 96005931785238e1a24febf65ffb5016273e8225 upstream.

This reverts commit 68d9e1fa24d9c7c2e527f49df8d18fb8cf0ec943

This change reduces rx sensitivity with no apparent extra benefit.
It looks like it was meant for testing in a specific scenario,
but it was never properly validated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: rmanohar@qca.qualcomm.com
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -958,11 +958,11 @@ static const u32 ar9300Common_rx_gain_ta
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x1a1a1a1a},
-	{0x0000a084, 0x1a1a1a1a},
-	{0x0000a088, 0x1a1a1a1a},
-	{0x0000a08c, 0x1a1a1a1a},
-	{0x0000a090, 0x171a1a1a},
+	{0x0000a080, 0x22222229},
+	{0x0000a084, 0x1d1d1d1d},
+	{0x0000a088, 0x1d1d1d1d},
+	{0x0000a08c, 0x1d1d1d1d},
+	{0x0000a090, 0x171d1d1d},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},


