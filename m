Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaAWPJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:09:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57594 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaAWPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:08:39 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/4] mfd: wm8994-core: Naturalise cross-architecture discrepancies
Date: Thu, 23 Jan 2014 15:05:55 +0000
Message-Id: <1390489556-9434-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390489556-9434-1-git-send-email-lee.jones@linaro.org>
References: <1390489556-9434-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we compile the WM8994 for a 64bit architecture we receive the following
warnings:

drivers/mfd/wm8994-core.c: In function ‘wm8994_i2c_probe’:
drivers/mfd/wm8994-core.c:639:19:
  warning: cast from pointer to integer of different size
    wm8994->type = (int)of_id->data;
                   ^

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/wm8994-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index ba04f1b..e6fab94 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -636,7 +636,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	if (i2c->dev.of_node) {
 		of_id = of_match_device(wm8994_of_match, &i2c->dev);
 		if (of_id)
-			wm8994->type = (int)of_id->data;
+			wm8994->type = (enum wm8994_type)of_id->data;
 	} else {
 		wm8994->type = id->driver_data;
 	}
-- 
1.8.3.2

