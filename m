Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaKYL42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:56:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaKYKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 045/254] i2c: at91: don't account as iowait
Date: Tue, 25 Nov 2014 10:36:35 +0000
Message-Id: <1416912004-5928-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 11cfbfb098b22d3e57f1f2be217cad20e2d48463 upstream.

iowait is for blkio [1]. I2C shouldn't use it.

[1] https://lkml.org/lkml/2014/11/3/317

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-at91.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index e96edab2e30b..30c8c1e738e1 100644
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
2.1.0

