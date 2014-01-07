Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAGXUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:20:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8997 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaAGXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:19:58 -0500
X-AuditID: cbfee68e-b7f566d000002344-f6-52cc8b9c3a37
Date: Tue, 07 Jan 2014 23:19:56 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mtd: nand: make more readable panic_nand_wait_ready() and
 nand_wait_ready()
To: computersforpeace@gmail.com, dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140107231625878@eunb.song
Msgkey: 20140107231625878@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140107231625878@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <19226555.341201389136795005.JavaMail.weblogic@epml09>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zLd053WeCDJ5t0bG4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqY8fHVR/aCBXwVrx68ZGpgfMPbxcjJISSgItHy/zsjiC0hYCLx6the
	KFtM4sK99WwQNcsYJZrnG8PUrL9+nbWLkQsoPp9R4mbzZlaQBAvQoEeTTzGD2GwC2hI/DlwF
	s4UFYiSW7pwGNkhEwEHi8Yln7CA2s4C3xJON31ggFshLTD59GSzOKyAocXLmExaIZUoSXU8+
	As3hAIorS1xr14YIS0jMmn6BFcLmlZjR/hSqXE5i2tc1zBC2tMT5WRvgfln8/TFUnF/i2O0d
	TCAjQXqf3A+GGbN78xc2CFtAYuqZg1Ct6hJPvt+FWsUnsWbhW6hVghKnr3Uzw/Te3zKXCeIr
	RYkp3Q+hPtSS+PJjHxu6r3gFnCT6J71hnsCoPAtJahaS9llI2pHVLGBkWcUomlqQXFCclF5k
	hBzXmxghSbBvB+PNA9aHGPczAqNkIrOUaHI+MI3mlcQbGpsZWZiamBobmVuaUShsYmphYWJE
	FWElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAG9C4L3MzvkPRPYn8Qd1hJk1uc
	YYGv61XGdIN0P8kXL6c2vzmvvZFVy2/h7ORdEcV8S4zOP3J0klO+uO7yxfozSVIyiZuV/xSt
	F2Ip+nolK/1Yfs2lZWJaiXVSN2eLT69qEQr5v+7rff3Y/lNWZW/0n7SxnHsUOHny9tIl3YZ2
	3llxUgJHdJRYijMSDbWYi4oTAX/1Vbj1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN053WeCDN4v1rS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GR9ffWQvWMBX8erBS6YGxje8XYycHEICKhIt/78zgtgSAiYS669fZ4WwxSQu3FvP1sXIBVQz
	n1HiZvNmsAQLUMOjyaeYQWw2AW2JHweugtnCAjESS3dOYwOxRQQcJB6feMYOYjMLeEs82fiN
	BWKZvMTk05fB4rwCghInZz5hgVimJNH15CPQHA6guLLEtXZtiLCExKzpF6Du4ZWY0f4UqlxO
	YtrXNcwQtrTE+VkbGGFuXvz9MVScX+LY7R1MICNBep/cD4YZs3vzFzYIW0Bi6pmDUK3qEk++
	34VaxSexZuFbqFWCEqevdTPD9N7fMpcJ4itFiSndD6E+1JL48mMfG7qveAWcJPonvWGewCg3
	C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUXmGkV5yYW1yal66XnJ+7iRGcoJ4t2sH477z1IUYB
	DkYlHt4GlTNBQqyJZcWVuYcYJTiYlUR4d7cAhXhTEiurUovy44tKc1KLDzEmA+NvIrOUaHI+
	MHnmlcQbGhsYGxpamhuYGhpZkCasJM4rfyspSEggPbEkNTs1tSC1CGYLEwenVAPjgzdZ1zf4
	1b7Z1edx/ugma8mn+7/9mXHiIdfZeGU3vR9P3K35Xn95syav7175Ykn1911eB5v3/edgaZx7
	T+22k/G0xuKiv5s6VZff7Fi+s+rTZ7Glx1afTDnPfFh+MscCsZ/8N31lP67InKGxKmFZSN3N
	+dsbCh4rXJFqe/ifI91VY4FuTnXuMSWW4oxEQy3mouJEAIXtDkKUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s07NKBiF022139


panic_nand_wait_ready() and nand_wait_ready() calls dev_ready() without checking if it exists.
This patch add check routine dev_ready() before run dev_ready()
and this makes the code more readable

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 drivers/mtd/nand/nand_base.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index bd39f7b..110db78 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -473,8 +473,10 @@ static void panic_nand_wait_ready(struct mtd_info *mtd, unsigned long timeo)
 
 	/* Wait for the device to get ready */
 	for (i = 0; i < timeo; i++) {
-		if (chip->dev_ready(mtd))
-			break;
+		if(chip->dev_ready){
+			if (chip->dev_ready(mtd))
+				break;
+		}
 		touch_softlockup_watchdog();
 		mdelay(1);
 	}
@@ -493,8 +495,10 @@ void nand_wait_ready(struct mtd_info *mtd)
 	led_trigger_event(nand_led_trigger, LED_FULL);
 	/* Wait until command is processed or timeout occurs */
 	do {
-		if (chip->dev_ready(mtd))
-			break;
+		if(chip->dev_ready){
+			if (chip->dev_ready(mtd))
+				break;
+		}
 		touch_softlockup_watchdog();
 	} while (time_before(jiffies, timeo));
 	led_trigger_event(nand_led_trigger, LED_OFF);
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
