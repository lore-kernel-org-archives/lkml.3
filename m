Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaBUNOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:14:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaBUNCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 35/60] spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true
Date: Fri, 21 Feb 2014 13:01:02 +0000
Message-Id: <1392987687-15367-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit f7db1588d6028c97c098bb6445eaabc56a25fed8 upstream.

Otherwise, spi_setup() fails with unsupported mode bits message.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-nuc900.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index dae8be2..f244d19 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -374,6 +374,8 @@ static int __devinit nuc900_spi_probe(struct platform_device *pdev)
 	init_completion(&hw->done);
 
 	master->mode_bits          = SPI_MODE_0;
+	if (hw->pdata->lsb)
+		master->mode_bits |= SPI_LSB_FIRST;
 	master->num_chipselect     = hw->pdata->num_cs;
 	master->bus_num            = hw->pdata->bus_num;
 	hw->bitbang.master         = hw->master;
-- 
1.9.0

