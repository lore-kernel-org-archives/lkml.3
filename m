Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3AYIJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:09:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54310 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3AYIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:09:33 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0P89LaP007779, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: <adam.lee@canonical.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH] MFD:rtsx:Avoid kernel panic if rtsx_pci_sdmmc not probed
Date: Fri, 25 Jan 2013 16:09:19 +0800
Message-ID: <1359101359-20144-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

If rtsx_pci_sdmmc is not probed, function pointer pcr->slots[].card_event
will point to NULL, and thus rtsx_pci_card_detect will reference a NULL pointer.
Check card_event pointer before referencing it can avoid kernel panic.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 910200e..9fc5700 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -786,10 +786,10 @@ static void rtsx_pci_card_detect(struct work_struct *work)
 
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
-	if (card_detect & SD_EXIST)
+	if ((card_detect & SD_EXIST) && pcr->slots[RTSX_SD_CARD].card_event)
 		pcr->slots[RTSX_SD_CARD].card_event(
 				pcr->slots[RTSX_SD_CARD].p_dev);
-	if (card_detect & MS_EXIST)
+	if ((card_detect & MS_EXIST) && pcr->slots[RTSX_MS_CARD].card_event)
 		pcr->slots[RTSX_MS_CARD].card_event(
 				pcr->slots[RTSX_MS_CARD].p_dev);
 }
-- 
1.7.9.5

