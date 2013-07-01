Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GAIll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:41:41 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34625 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3GAIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:17 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 09/13] sound: atmel-pcm: don't return ok if pcm-dma is not implemented
Date: Mon,  1 Jul 2013 10:39:34 +0200
Message-Id: <1372667978-4718-10-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If DMA is not selected, atmel_pcm_dma_platform_register() should fail.
Like that, the driver knows it can't use it.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 sound/soc/atmel/atmel-pcm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/atmel-pcm.h b/sound/soc/atmel/atmel-pcm.h
index 12ae814..c0a01fa 100644
--- a/sound/soc/atmel/atmel-pcm.h
+++ b/sound/soc/atmel/atmel-pcm.h
@@ -109,7 +109,7 @@ void atmel_pcm_dma_platform_unregister(struct device *dev);
 #else
 static inline int atmel_pcm_dma_platform_register(struct device *dev)
 {
-	return 0;
+	return -1;
 }
 static inline void atmel_pcm_dma_platform_unregister(struct device *dev)
 {
-- 
1.7.10.4

