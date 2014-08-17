Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaHQO3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:29:01 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34470 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHQO27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:28:59 -0400
Date: Sun, 17 Aug 2014 07:28:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: atmel_mxt_ts - remove unneeded check
Message-ID: <20140817142851.GA21153@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following issue reported by Coverity:

** CID 1231785:  Unsigned compared against 0  (NO_EFFECT)
/drivers/input/touchscreen/atmel_mxt_ts.c: 1157 in mxt_prepare_cfg_mem()

The variable 'byte_offset' is declared as unsigned int and therefore can never
be less than 0.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index db178ed..8780c9a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1154,7 +1154,7 @@ static int mxt_prepare_cfg_mem(struct mxt_data *data,
 
 			byte_offset = reg + i - cfg_start_ofs;
 
-			if (byte_offset >= 0 && byte_offset < config_mem_size) {
+			if (byte_offset < config_mem_size) {
 				*(config_mem + byte_offset) = val;
 			} else {
 				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
