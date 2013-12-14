Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3LNNid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:38:33 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60435 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNNib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:38:31 -0500
Date: Sat, 14 Dec 2013 19:08:22 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ferruh Yigit <fery@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] drivers: input: Include appropriate header file in
 cyttsp_i2c_common.c
Message-ID: <20131214133822.GA13124@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes appropriate header file cyttsp4_core.h in
touchscreen/cyttsp_i2c_common.c because functions
cyttsp_i2c_read_block_data() and cyttsp_i2c_write_block_data()
have their prototype declaration in cyttsp4_core.h.

Thus, it also eliminates the following warning in cyttsp_i2c_common.c:
drivers/input/touchscreen/cyttsp_i2c_common.c:34:5: warning: no previous prototype for ‘cyttsp_i2c_read_block_data’ [-Wmissing-prototypes]
drivers/input/touchscreen/cyttsp_i2c_common.c:64:5: warning: no previous prototype for ‘cyttsp_i2c_write_block_data’ [-Wmissing-prototypes]


Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/input/touchscreen/cyttsp_i2c_common.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/touchscreen/cyttsp_i2c_common.c b/drivers/input/touchscreen/cyttsp_i2c_common.c
index 1d7b6f1..ccefa56 100644
--- a/drivers/input/touchscreen/cyttsp_i2c_common.c
+++ b/drivers/input/touchscreen/cyttsp_i2c_common.c
@@ -31,6 +31,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "cyttsp4_core.h"
+
 int cyttsp_i2c_read_block_data(struct device *dev, u8 *xfer_buf,
 				      u16 addr, u8 length, void *values)
 {
-- 
1.7.9.5

