Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbbATHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:16:56 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:22596 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbATHQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:16:16 -0500
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 20 Jan 2015 08:16:14 +0100
X-ME-IP: 90.20.161.114
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] crypto: atmel: Free memory in error path
Date: Tue, 20 Jan 2015 08:15:52 +0100
Message-Id: <1421738152-30462-1-git-send-email-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.1.0
X-Antivirus: avast! (VPS 150119-1, 19/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If only one of the 2 __get_free_pages fails, then there is a memory leak.

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/atmel-aes.c  | 2 +-
 drivers/crypto/atmel-tdes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 53d1c33..6597aac 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -673,9 +673,9 @@ err_map_out:
 	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
 		DMA_TO_DEVICE);
 err_map_in:
+err_alloc:
 	free_page((unsigned long)dd->buf_out);
 	free_page((unsigned long)dd->buf_in);
-err_alloc:
 	if (err)
 		pr_err("error: %d\n", err);
 	return err;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 5e7c896..258772d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -376,9 +376,9 @@ err_map_out:
 	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
 		DMA_TO_DEVICE);
 err_map_in:
+err_alloc:
 	free_page((unsigned long)dd->buf_out);
 	free_page((unsigned long)dd->buf_in);
-err_alloc:
 	if (err)
 		pr_err("error: %d\n", err);
 	return err;
-- 
2.1.0

