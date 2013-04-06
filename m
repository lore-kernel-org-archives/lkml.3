Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab3DFGnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:43:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61048 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3DFGnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:43:50 -0400
X-AuditID: cbfee68d-b7f786d000005188-16-515fc425fd04
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
In-reply-to: <001701ce3291$f3f29090$dbd7b1b0$%han@samsung.com>
Subject: [PATCH 3/6] mfd: ezx-pcap: use spi_get_drvdata() and spi_set_drvdata()
Date: Sat, 06 Apr 2013 15:43:48 +0900
Message-id: <001901ce3292$1803f690$480be3b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ykfPaYTuV5qPCS+S/kzkYYtE9uwAABY5g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY13VI/GBBhNP8FlcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujKW7LjAXfOaoeNryiKmBcRd7
	FyMHh4SAicT+h6ZdjJxAppjEhXvr2boYuTiEBJYxSjw69YMJImEisal7MiNEYjqjxKmjH5kg
	nF+MEs+mtLGAVLEJqEl8+XKYHcQWEdCS6D52ng1kA7OAi8TRaSIgYSEBW4nNsw6BlXMK2Emc
	+b+NEcQWFvCX2LLuBTOIzSKgKrHy4hMwmxeofsL776wQtqDEj8n3wHqZgcav33mcCcKWl9i8
	5i0zxDPqEo/+6kJcYCSx+Xs3VImIxL4X78DulxDYxS7R9uMPK8QuAYlvk0HuAemVldh0gBni
	X0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC
	Yq93B+PtA9aHGJOB1k9klhJNzgfGbl5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGG+9DdcMu5KkYlbOpP1GxXFq9bFMb6sv28797bWyeDptsVrz
	2vi0coezFw43yv38lT7xykzROzyq/BvTayZYiPu+mLfP+6NUsUKpZH3rMpMk3vLuxH+fnr65
	r5Gpf2avz5HVN89zLLz6b90Bg5O7ao/dXDS9yWvDodP5Zr9vsQsdevmkMjDb444SS3FGoqEW
	c1FxIgCaY7ZX0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV3VI/GBBu0vOS0uL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8bSXReYCz5zVDxtecTUwLiLvYuRk0NCwERiU/dkRghbTOLCvfVsXYxcHEIC0xklTh39
	yATh/GKUeDaljQWkik1ATeLLl8Ng3SICWhLdx84DdXBwMAu4SBydJgISFhKwldg86xBYOaeA
	ncSZ/9vAFggL+EtsWfeCGcRmEVCVWHnxCZjNC1Q/4f13VghbUOLH5HtgvcxA49fvPM4EYctL
	bF7zlhlklYSAusSjv7oQFxhJbP7eDVUiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzi2n0nvYFzVYHGIUYCDUYmH1+J2XKAQa2JZcWXuIUYJ
	DmYlEV7Z50Ah3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemnbySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYIzhu5+gWPa2zPDxXpGfFl9O6l9Y3Hzy0d2l
	EVaeO29rH7qXclIgWevXxi8CjS5HIkQf/12ovHLz6ZeNucc+ph0PXvvwoSmL6nahFaWJGX4y
	c3eZBHLFhRme8DJk/ivxW7fuz4S8qlDnT0H8Sv+3LBU84Xlk3ZwNjQnX/xQUbZ9c3772ZBWT
	W5wSS3FGoqEWc1FxIgAZASWUMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ezx-pcap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index b7a61f0..bbebe8d 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -393,7 +393,7 @@ static int pcap_add_subdev(struct pcap_chip *pcap,
 
 static int ezx_pcap_remove(struct spi_device *spi)
 {
-	struct pcap_chip *pcap = dev_get_drvdata(&spi->dev);
+	struct pcap_chip *pcap = spi_get_drvdata(spi);
 	struct pcap_platform_data *pdata = spi->dev.platform_data;
 	int i, adc_irq;
 
@@ -441,7 +441,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	mutex_init(&pcap->adc_mutex);
 	INIT_WORK(&pcap->isr_work, pcap_isr_work);
 	INIT_WORK(&pcap->msr_work, pcap_msr_work);
-	dev_set_drvdata(&spi->dev, pcap);
+	spi_set_drvdata(spi, pcap);
 
 	/* setup spi */
 	spi->bits_per_word = 32;
-- 
1.7.2.5


