Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab3GCTA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:00:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619Ab3GCTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:19 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Ds0yDnEEwKAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=I48ALVajmC4A:10 a=jdP34snFAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=aPdjxt-I0YbHx5DJs0QA:9 a=9mtjllxcxZAA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184106.654324601@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <rmanohar@qca.qualcomm.com>, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [120/141] Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0120-Revert-ath9k_hw-Update-rx-gain-initval-to-improve-rx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 96005931785238e1a24febf65ffb5016273e8225 ]

This reverts commit 68d9e1fa24d9c7c2e527f49df8d18fb8cf0ec943

This change reduces rx sensitivity with no apparent extra benefit.
It looks like it was meant for testing in a specific scenario,
but it was never properly validated.

Cc: rmanohar@qca.qualcomm.com
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 6f7cf49..2ad5703 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -778,11 +778,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
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
-- 
1.7.10.4


