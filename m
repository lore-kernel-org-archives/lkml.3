Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935933Ab3BTGNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:13:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17512 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814Ab3BTGNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:13:08 -0500
X-AuditID: cbfee68e-b7fc26d000001938-dd-51246972ee20
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 08/11] mfd: ezx-pcap: use devm_request_irq() and devm_kzalloc()
Date: Wed, 20 Feb 2013 15:13:06 +0900
Message-id: <002d01ce0f31$5940b4b0$0bc21e10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAHM6g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ92iTJVAg2dXDC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGva8n2Qr2CVdM//qJpYHxDn8XIyeHhICJxI/T29khbDGJC/fW
	s3UxcnEICSxjlDjdsIYFpmjSgk5miMQiRonDj0+zQjizmSQe7VjGBFLFJqAm8eXLYbBRIgJa
	Et3HzgON4uBgFnCRODpNBCQsJGAr8X3tP1YQm1PATmLXo/NgtrCAv8Sxw7dYQMpZBFQljr2M
	AwnzApXfOzSFBcIWlPgx+R6YzQw0ff3O40wQtrzE5jVvmUFaJQTUJR791YU4wEjiyZfnUOUi
	EvtevGMEuVhCYBG7xNnVm8F6WQQEJL5NPsQC0SsrsekAM8S7khIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoTEVd8OxpsHrA8xJgOtn8gsJZqc
	D4zLvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	nKKg/8fnyaXVb+zlmsIPrN82W1lb/vP0/HXJ1oFz1uV/0fTVME046rh07ffsEzlmM9ltfHOO
	vW12S19f9+dR7IEw77muMeo8S021vgv2T87Yu+/P/MLrkQcZ1Dfu6Ih6tCBWe82tO2vXyvlN
	1Dh4a6qWUebDS4o/23nYQrVbT9zVeWe1wkQkRImlOCPRUIu5qDgRAGcIlzPBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG5RpkqgwbKVOhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x497Xk2wF+4Qrpn/9xNLA
	eIe/i5GTQ0LARGLSgk5mCFtM4sK99WxdjFwcQgKLGCUOPz7NCuHMZpJ4tGMZE0gVm4CaxJcv
	h9lBbBEBLYnuY+eBOjg4mAVcJI5OEwEJCwnYSnxf+48VxOYUsJPY9eg8mC0s4C9x7PAtFpBy
	FgFViWMv40DCvEDl9w5NYYGwBSV+TL4HZjMDTV+/8zgThC0vsXnNW2aQVgkBdYlHf3UhDjCS
	ePLlOVS5iMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOCofSa1g3Flg8UhRgEORiUeXo35yoFCrIllxZW5hxglOJiVRHibnVQChXhTEiurUovy
	44tKc1KLDzEmA/05kVlKNDkfmFDySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1
	tSC1CGYLEwenVANjc8kELqP1zVk7k9p7nkleyHVcvaPgRldlm6XirPev9u26IcBy0C3b+9QH
	D87H76eueGH1fMZROY0Qlc2mfyYENiSl3BfsLz68cm2AQYeEvJKsbP3ni5NW+16ZnPr4loX/
	tgffo3uDTwisEX/+/Mj6H9fnZ87zX3mRQdLA4cy3moiwOKfVzjdfKrEUZyQaajEXFScCACFm
	37IeAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_irq() and devm_kzalloc() to make cleanup paths
more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ezx-pcap.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index b7a61f0..8dea3a9 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -403,7 +403,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
 	/* cleanup ADC */
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
 				PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
-	free_irq(adc_irq, pcap);
 	mutex_lock(&pcap->adc_mutex);
 	for (i = 0; i < PCAP_ADC_MAXQ; i++)
 		kfree(pcap->adc_queue[i]);
@@ -415,8 +414,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
 
 	destroy_workqueue(pcap->workqueue);
 
-	kfree(pcap);
-
 	return 0;
 }
 
@@ -431,7 +428,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	if (!pdata)
 		goto ret;
 
-	pcap = kzalloc(sizeof(*pcap), GFP_KERNEL);
+	pcap = devm_kzalloc(&spi->dev, sizeof(*pcap), GFP_KERNEL);
 	if (!pcap) {
 		ret = -ENOMEM;
 		goto ret;
@@ -448,7 +445,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	spi->mode = SPI_MODE_0 | (pdata->config & PCAP_CS_AH ? SPI_CS_HIGH : 0);
 	ret = spi_setup(spi);
 	if (ret)
-		goto free_pcap;
+		goto ret;
 
 	pcap->spi = spi;
 
@@ -458,7 +455,7 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	if (!pcap->workqueue) {
 		ret = -ENOMEM;
 		dev_err(&spi->dev, "can't create pcap thread\n");
-		goto free_pcap;
+		goto ret;
 	}
 
 	/* redirect interrupts to AP, except adcdone2 */
@@ -491,7 +488,8 @@ static int ezx_pcap_probe(struct spi_device *spi)
 	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
 					PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
 
-	ret = request_irq(adc_irq, pcap_adc_irq, 0, "ADC", pcap);
+	ret = devm_request_irq(&spi->dev, adc_irq, pcap_adc_irq, 0,
+				"ADC", pcap);
 	if (ret)
 		goto free_irqchip;
 
@@ -510,15 +508,11 @@ static int ezx_pcap_probe(struct spi_device *spi)
 
 remove_subdevs:
 	device_for_each_child(&spi->dev, NULL, pcap_remove_subdev);
-/* free_adc: */
-	free_irq(adc_irq, pcap);
 free_irqchip:
 	for (i = pcap->irq_base; i < (pcap->irq_base + PCAP_NIRQS); i++)
 		irq_set_chip_and_handler(i, NULL, NULL);
 /* destroy_workqueue: */
 	destroy_workqueue(pcap->workqueue);
-free_pcap:
-	kfree(pcap);
 ret:
 	return ret;
 }
-- 
1.7.2.5


