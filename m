Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3BVIJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:09:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3BVIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:09:20 -0500
X-AuditID: cbfee691-b7f556d000001a24-a9-512727ae662e
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, alsa-devel@alsa-project.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH v2 3/4] spi: s3c64xx: add dma maxburst size initialization
Date: Fri, 22 Feb 2013 17:09:18 +0900
Message-id: <001b01ce10d3$e9f78620$bde69260$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q0zRNgYHsZtryQK2Zcgnt7X5e4wAABD9gAAAJYXA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zY9116uqBBms3qFtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8b9vMUjCPt2L/h0PMDYzPuboYOTkkBEwk7l67zwph
	i0lcuLeerYuRi0NIYBmjxJHZK1lgin79uMQEkZjOKPHmwhxmCOcvo8SGrz/ZQKrYBDQlZnyf
	zg5iiwhsZpSY/DoLpIhZ4DSTxILL7UAdHEAd3BKrm4NAajgFeCTW/elkBrGFBbwkJkz4BjaH
	RUBV4sKap0wgNq+ArcTZeRfBWiUE1CUe/dWFGG8lsWjOO7BVzAIiEvtevGMEWSUh8JtNYvrs
	GewQcwQkvk0+xALRKyux6QAzxDOSEgdX3GCZwCg6C0n7AkbGVYyiqQXJBcVJ6UWmesWJucWl
	eel6yfm5mxghQT1xB+P9A9aHGJOBRk9klhJNzgdGRV5JvKGxsYmZiamJuaWpuSlpwkrivPKX
	ZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MIrc7Zu568/sOf/dGjJN5sv/5T9W+8dHfsG8
	23yFgeYvrc/4e7rN+L/Y/ESt96kd/n8L/OaXz7J6bVARXnDlb8Gvc/KuL1Xbz0aXFb24Pe1u
	eHqM+KrpFlcezLjKuK9F4c0S92uN/A88LvbPiltsdTqHmcNib/PmvktdEdHak0vXpq16HOwp
	s0WJpTgj0VCLuag4EQDYo0P8gAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQd116uqBBnf2KFlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvG/bzFIwj7di
	/4dDzA2Mz7m6GDk5JARMJH79uMQEYYtJXLi3nq2LkYtDSGA6o8SbC3OYIZy/jBIbvv5kA6li
	E9CUmPF9OjuILSKwmVFi8usskCJmgdNMEgsutwN1cAB1cEusbg4CqeEU4JFY96eTGcQWFvCS
	mDDhG9gcFgFViQtrnoJt5hWwlTg77yJYq4SAusSjv7oQ460kFs15B7aKWUBEYt+Ld4wTGPln
	IXEXMDKuYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOmWdSOxhXNlgcYhTgYFTi4W1wUQsU
	Yk0sK67MPcQowcGsJMK7SEE9UIg3JbGyKrUoP76oNCe1+BBjMtCBE5mlRJPzgfGcVxJvaGxi
	ZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoYM96+eFYm+caKh6tyhZNG
	1q6QgHfrrsZGhU+XmPI8xFD6oYZe2N11ohxmG+VXH1/dbXWz6YoXP/P1Q69iJeafavX7XyLM
	y2/NN2H9RtmJX/s5pYWPh6vcDlB9WfNzdvnFvxqGOey390cnGKj9D8/o2WXg08h+Rd5Lpuvu
	V0GT17XRAn1T5A8rsRRnJBpqMRcVJwIAw6dLld0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dma maxburst size initialization.
The maxburst should be set by MODE_CFGn.DMA_TYPE,
because the pl330 dma driver supports burst mode.

Signed-off-by: Hyeonkook Kim <hk619.kim@samsung.com>
---
 drivers/spi/spi-s3c64xx.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index e862ab8..5e6cafe 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -287,10 +287,20 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 	struct s3c64xx_spi_driver_data *sdd;
 	struct samsung_dma_prep info;
 	struct samsung_dma_config config;
+	void __iomem *regs;
+	unsigned int mode_cfg;

 	if (dma->direction == DMA_DEV_TO_MEM) {
 		sdd = container_of((void *)dma,
 			struct s3c64xx_spi_driver_data, rx_dma);
+
+		regs = sdd->regs;
+		mode_cfg = readl(regs + S3C64XX_SPI_MODE_CFG);
+		if (mode_cfg & S3C64XX_SPI_MODE_4BURST)
+			config.maxburst = 4;
+		else
+			config.maxburst = 1;
+
 		config.direction = sdd->rx_dma.direction;
 		config.fifo = sdd->sfr_start + S3C64XX_SPI_RX_DATA;
 		config.width = sdd->cur_bpw / 8;
@@ -298,6 +308,14 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 	} else {
 		sdd = container_of((void *)dma,
 			struct s3c64xx_spi_driver_data, tx_dma);
+
+		regs = sdd->regs;
+		mode_cfg = readl(regs + S3C64XX_SPI_MODE_CFG);
+		if (mode_cfg & S3C64XX_SPI_MODE_4BURST)
+			config.maxburst = 4;
+		else
+			config.maxburst = 1;
+
 		config.direction =  sdd->tx_dma.direction;
 		config.fifo = sdd->sfr_start + S3C64XX_SPI_TX_DATA;
 		config.width = sdd->cur_bpw / 8;
--
1.7.5.4



