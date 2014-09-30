Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaI3ViG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaI3ViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Jorge A. Ventura" <jorge.araujo.ventura@gmail.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/103] spi/omap-mcspi: Fix the spi task hangs waiting dma_rx
Date: Tue, 30 Sep 2014 14:30:43 -0700
Message-Id: <1412112708-27356-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jorge A. Ventura" <jorge.araujo.ventura@gmail.com>

commit 3d0763c006f8da1b44a9f5f9a21187f5b8f674f4 upstream.

The spi hangs waiting the completion of omap2_mcspi_rx_callback.

Signed-off-by: Jorge A. Ventura <jorge.araujo.ventura@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-omap2-mcspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 443df39..4935467 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -320,7 +320,8 @@ static void omap2_mcspi_set_fifo(const struct spi_device *spi,
 disable_fifo:
 	if (t->rx_buf != NULL)
 		chconf &= ~OMAP2_MCSPI_CHCONF_FFER;
-	else
+
+	if (t->tx_buf != NULL)
 		chconf &= ~OMAP2_MCSPI_CHCONF_FFET;
 
 	mcspi_write_chconf0(spi, chconf);
-- 
1.9.1

