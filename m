Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaLIGfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 01:35:04 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61153 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLIGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 01:35:01 -0500
Date: Tue, 9 Dec 2014 08:34:56 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: dmitry.torokhov@gmail.com
Cc: LW@KARO-electronics.de, B38611@freescale.com, maksqwe1@ukr.net,
        jg1.han@samsung.com, linux@rasmusvillemoes.dk, fabf@skynet.be,
        asaf.vertz@tandemg.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] input: edt-ft5x06: fixed a macro coding style issue
Message-ID: <20141209063456.GA15121@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, macros with complex values should be
enclosed in parentheses.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/input/touchscreen/edt-ft5x06.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index ee3434f..6db9253 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -849,10 +849,11 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 	return 0;
 }
 
-#define EDT_ATTR_CHECKSET(name, reg) \
+#define EDT_ATTR_CHECKSET(name, reg) { \
 	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
 	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
-		edt_ft5x06_register_write(tsdata, reg, pdata->name)
+		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
+}
 
 #define EDT_GET_PROP(name, reg) {				\
 	u32 val;						\
-- 
1.7.0.4

