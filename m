Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaCCS6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaCCS6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 30/67] spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true
Date: Mon,  3 Mar 2014 10:55:18 -0800
Message-Id: <1393872955-28810-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit f7db1588d6028c97c098bb6445eaabc56a25fed8 upstream.

Otherwise, spi_setup() fails with unsupported mode bits message.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-nuc900.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index b3f9ec8..2d7b7c8 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -374,6 +374,8 @@ static int nuc900_spi_probe(struct platform_device *pdev)
 	init_completion(&hw->done);
 
 	master->mode_bits          = SPI_MODE_0;
+	if (hw->pdata->lsb)
+		master->mode_bits |= SPI_LSB_FIRST;
 	master->num_chipselect     = hw->pdata->num_cs;
 	master->bus_num            = hw->pdata->bus_num;
 	hw->bitbang.master         = hw->master;
-- 
1.8.3.2

