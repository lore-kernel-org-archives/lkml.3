Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaGFSc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:32:58 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:48923 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaGFSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:32:57 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: intelfb: intelfb_i2c.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:34:12 +0200
Message-Id: <1404671652-18374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/intelfb/intelfb_i2c.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/intelfb/intelfb_i2c.c b/drivers/video/fbdev/intelfb/intelfb_i2c.c
index 3300bd3..4df2f1f 100644
--- a/drivers/video/fbdev/intelfb/intelfb_i2c.c
+++ b/drivers/video/fbdev/intelfb/intelfb_i2c.c
@@ -55,22 +55,20 @@ static void intelfb_gpio_setscl(void *data, int state)
 {
 	struct intelfb_i2c_chan *chan = data;
 	struct intelfb_info *dinfo = chan->dinfo;
-	u32 val;
 
 	OUTREG(chan->reg, (state ? SCL_VAL_OUT : 0) |
 	       SCL_DIR | SCL_DIR_MASK | SCL_VAL_MASK);
-	val = INREG(chan->reg);
+	INREG(chan->reg);
 }
 
 static void intelfb_gpio_setsda(void *data, int state)
 {
 	struct intelfb_i2c_chan *chan = data;
 	struct intelfb_info *dinfo = chan->dinfo;
-	u32 val;
 
 	OUTREG(chan->reg, (state ? SDA_VAL_OUT : 0) |
 	       SDA_DIR | SDA_DIR_MASK | SDA_VAL_MASK);
-	val = INREG(chan->reg);
+	INREG(chan->reg);
 }
 
 static int intelfb_gpio_getscl(void *data)
-- 
1.7.10.4

