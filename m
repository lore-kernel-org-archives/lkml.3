Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaANDN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:13:58 -0500
Received: from nm50-vm3.bullet.mail.gq1.yahoo.com ([67.195.87.243]:41357 "EHLO
	nm50-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbaANDNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:13:55 -0500
X-Yahoo-Newman-Id: 188391.34954.bm@smtp205.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: O1wnqs0VM1m9PMzd4JqW2pDHh9kepUN.Eq6.cPYrmO2aA82
 RII_hO5CMeo6v4reh7uKegwgVV4AC5fLN59qZMT8L0fP9M1lfCkLseoy9vS7
 gABTcrcVx.Pv_NIG1ktR.GIZtwqQkh5Rg__K6ydITfatbZ13zVXceV3noNQG
 P9dtbpDYTMQ94svQ2Ov6.IELTJ0gwimTl.rHWE4V2GWsl_unANw.EuheVN4D
 KrR.BdIOuTFDaWlS0.sm4K_5TtdZF5sJo3xfTd0XAubRQ22oWUKuDZAeGZe7
 _dQTGWvli.UYUK_igzF_oJZIvS5SG2ak1YCuqwZDJPyF9HU_V_nFWBVtRgzS
 KvVam77WzT4fuGIRcGlN0TjCipCzdgxtr7QVOuJyVdFAoZkTcdUR0GVyrG2H
 FuCNi8GYZZPl96PPn5_59k4XSLtEUGU.uU8PkL6DyDbjKcgbR_tnT4g8AAer
 GNxtxIm.d5cZyEbQg8ZIyQWivAvxp19hzY2C8Rugl3ycxYCIQQtlLgDKoLV3
 xpBmqJV8HOgz8UWkhC4LdBRYO6.cO5g--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp205.mail.gq1.yahoo.com with SMTP; 13 Jan 2014 19:13:54 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: move trailing statement to next line in ni_mio_common.c
Date: Mon, 13 Jan 2014 21:13:48 -0600
Message-Id: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for ni_mio_common.c silences a checkpatch error due to a
trailing statement.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 457b884..dba19e9 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -692,7 +692,8 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
 		/*  Flush the 6143 data FIFO */
 		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
 		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
-		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
+		while (ni_readl(AIFIFO_Status_6143) & 0x10)
+			;	/*  Wait for complete */
 	} else {
 		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
 		if (board->reg_type == ni_reg_625x) {
-- 
1.8.4.2

