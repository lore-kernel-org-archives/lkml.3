Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbaKROQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:16:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbaKROK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 200/206] i2c: at91: don't account as iowait
Date: Tue, 18 Nov 2014 15:09:15 +0100
Message-Id: <f95c7176a5ddd27632da6b1dbabb529e20f5581f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 11cfbfb098b22d3e57f1f2be217cad20e2d48463 upstream.

iowait is for blkio [1]. I2C shouldn't use it.

[1] https://lkml.org/lkml/2014/11/3/317

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-at91.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 2f6d43bd0728..174445303b9f 100644
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
2.1.3

