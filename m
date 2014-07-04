Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196AbaGDMwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:52:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23340 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaGDMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:52:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c8-53b6a396602f
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/3] extcon: max77693: Differentiate info message for easier
 debugging
Date: Fri, 04 Jul 2014 15:51:25 +0300
Message-id: <19fae0c2a773caf29bcc51196f7c6bd896c9663f.1404478227.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7rTFm8LNmjbLmtx/ctzVotbf/cy
	W3SefcJscXnXHDaL240r2BxYPfq2rGL0+LxJLoApissmJTUnsyy1SN8ugStjyZEGxoL3fBVd
	xzUbGI/ydDFyckgImEhsWriTEcIWk7hwbz1bFyMXh5DAUkaJW8sWM0E4nUwSUx6dBatiE9CT
	2ND8g72LkYNDREBSomWfGUgNs8BcRok7cy+wgNQIC0RIXJ28gA3EZhFQlTi38BhYnFcgTuLx
	87tQ2+QkTh6bzApicwpYSez8+IkdxBYSsJR4/LmZEZf4BEb+BYwMqxhFU0uTC4qT0nMN9YoT
	c4tL89L1kvNzNzFCQurLDsbFx6wOMQpwMCrx8Dau2BAsxJpYVlyZe4hRgoNZSYRXa862YCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2My9peqknxC8/9Wpazsbvr287fRzd7cq4vdU9oyT3iw9Vz
	cc51zVd3uyWsuapM59QlN8h2JwS65t8xP+yc2nFqpo7PpgPhBz2m5YW/un3mQcwnObNz2+rf
	LXx8huHr7NV9q48fXL09efnz54xbOnVsar4GGG2JXigxr9/tKXtLeJN2/fnTv2UmK7EUZyQa
	ajEXFScCAB4M5oIHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 0e9f734..1b194b3 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -491,7 +491,7 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 	char dock_name[CABLE_NAME_MAX];
 
 	dev_info(info->dev,
-		"external connector is %s (adc:0x%02x)\n",
+		"external connector (doc) is %s (adc:0x%02x)\n",
 		attached ? "attached" : "detached", cable_type);
 
 	switch (cable_type) {
@@ -654,7 +654,7 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 	u8 path = CONTROL1_SW_OPEN;
 
 	dev_info(info->dev,
-		"external connector is %s (adc:0x%02x)\n",
+		"external connector (jig) is %s (adc:0x%02x)\n",
 		attached ? "attached" : "detached", cable_type);
 
 	switch (cable_type) {
@@ -700,7 +700,7 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 				MAX77693_CABLE_GROUP_ADC, &attached);
 
 	dev_info(info->dev,
-		"external connector is %s (adc:0x%02x, prev_adc:0x%x)\n",
+		"external connector (adc) is %s (adc:0x%02x, prev_adc:0x%x)\n",
 		attached ? "attached" : "detached", cable_type,
 		info->prev_cable_type);
 
@@ -809,7 +809,7 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 				MAX77693_CABLE_GROUP_CHG, &attached);
 
 	dev_info(info->dev,
-		"external connector is %s(chg_type:0x%x, prev_chg_type:0x%x)\n",
+		"external connector (chg) is %s(chg_type:0x%x, prev_chg_type:0x%x)\n",
 			attached ? "attached" : "detached",
 			chg_type, info->prev_chg_type);
 
-- 
1.9.1

