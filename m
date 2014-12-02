Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbaLBT2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:28:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933866AbaLBT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 042/121] i2c: at91: don't account as iowait
Date: Tue,  2 Dec 2014 11:18:41 -0800
Message-Id: <1417548000-1794-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 11cfbfb098b22d3e57f1f2be217cad20e2d48463 upstream.

iowait is for blkio [1]. I2C shouldn't use it.

[1] https://lkml.org/lkml/2014/11/3/317

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-at91.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index a10632e..50fea6c 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -434,7 +434,7 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 		}
 	}
 
-	ret = wait_for_completion_io_timeout(&dev->cmd_complete,
+	ret = wait_for_completion_timeout(&dev->cmd_complete,
 					     dev->adapter.timeout);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");
-- 
1.9.1

