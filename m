Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaGEM0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:26:46 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41635 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaGEM0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:26:45 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: mb862xx: mb862xx-i2c.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:28:00 +0200
Message-Id: <1404563280-20023-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mb862xx/mb862xx-i2c.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/mb862xx/mb862xx-i2c.c b/drivers/video/fbdev/mb862xx/mb862xx-i2c.c
index c87e17a..6b9769f 100644
--- a/drivers/video/fbdev/mb862xx/mb862xx-i2c.c
+++ b/drivers/video/fbdev/mb862xx/mb862xx-i2c.c
@@ -20,7 +20,6 @@
 
 static int mb862xx_i2c_wait_event(struct i2c_adapter *adap)
 {
-	struct mb862xxfb_par *par = adap->algo_data;
 	u32 reg;
 
 	do {
@@ -48,8 +47,6 @@ static int mb862xx_i2c_do_address(struct i2c_adapter *adap, int addr)
 
 static int mb862xx_i2c_write_byte(struct i2c_adapter *adap, u8 byte)
 {
-	struct mb862xxfb_par *par = adap->algo_data;
-
 	outreg(i2c, GC_I2C_DAR, byte);
 	outreg(i2c, GC_I2C_BCR, I2C_START);
 	if (!mb862xx_i2c_wait_event(adap))
@@ -59,8 +56,6 @@ static int mb862xx_i2c_write_byte(struct i2c_adapter *adap, u8 byte)
 
 static int mb862xx_i2c_read_byte(struct i2c_adapter *adap, u8 *byte, int last)
 {
-	struct mb862xxfb_par *par = adap->algo_data;
-
 	outreg(i2c, GC_I2C_BCR, I2C_START | (last ? 0 : I2C_ACK));
 	if (!mb862xx_i2c_wait_event(adap))
 		return 0;
-- 
1.7.10.4

