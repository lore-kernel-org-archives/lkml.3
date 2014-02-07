Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaBGNI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:08:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaBGLs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonas Gorski <jogo@openwrt.org>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 061/233] spi/bcm63xx: don't substract prepend length from total length
Date: Fri,  7 Feb 2014 11:44:40 +0000
Message-Id: <1391773652-25214-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jogo@openwrt.org>

commit 86b3bde003e6bf60ccb9c09b4115b8a2f533974c upstream.

The spi command must include the full message length including any
prepended writes, else transfers larger than 256 bytes will be
incomplete.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-bcm63xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 9fd7a39..49c21cd 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -169,8 +169,6 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 			       transfer_list);
 	}
 
-	len -= prepend_len;
-
 	init_completion(&bs->done);
 
 	/* Fill in the Message control register */
-- 
1.8.3.2

