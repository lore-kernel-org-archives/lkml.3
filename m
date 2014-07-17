Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbaGQMPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:15:40 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58336 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaGQMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:15:38 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc: dcb314@hotmail.com, davem@davemloft.net, herbert@gondor.apana.org.au,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 3/3] drivers/crypto/omap-{des,aes}.c: fix sanity checks
Date: Thu, 17 Jul 2014 15:15:24 +0300
Message-Id: <1405599324-11215-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned variable "total" was tested for negativity after subtraction
operation. 2 instances.
Replaced that with the test of minuend being greater than subtrahend
before the subtraction.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80421
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/crypto/omap-aes.c | 4 ++--
 drivers/crypto/omap-des.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index cb98fa5..413ed78 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1038,10 +1038,10 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 			}
 		}
 
+		BUG_ON(dd->total < AES_BLOCK_SIZE);
+
 		dd->total -= AES_BLOCK_SIZE;
 
-		BUG_ON(dd->total < 0);
-
 		/* Clear IRQ status */
 		status &= ~AES_REG_IRQ_DATA_OUT;
 		omap_aes_write(dd, AES_REG_IRQ_STATUS(dd), status);
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index b8bc84b..93aa213 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -965,10 +965,10 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 			}
 		}
 
+		BUG_ON(dd->total < DES_BLOCK_SIZE);
+
 		dd->total -= DES_BLOCK_SIZE;
 
-		BUG_ON(dd->total < 0);
-
 		/* Clear IRQ status */
 		status &= ~DES_REG_IRQ_DATA_OUT;
 		omap_des_write(dd, DES_REG_IRQ_STATUS(dd), status);
-- 
1.8.5.5

