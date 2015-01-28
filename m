Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbbA2CDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:03:19 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39090 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbbA2CDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:03:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@gmail.com>,
        Marcin Kostrzewa <marckostrzewa@gmail.com>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: addi-data: hwdrv_apci3501: Removed variables that is never used
Date: Wed, 28 Jan 2015 22:51:54 +0100
Message-Id: <1422481914-31418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 339519a..24126e3 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -93,7 +93,6 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
 {
 	struct apci3501_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
-	int i_Temp;
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 
@@ -135,7 +134,7 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
 		}
 	}
 
-	i_Temp = inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
+	inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
 	return insn->n;
 }
 
-- 
1.7.10.4

