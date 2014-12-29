Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaL2NCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:02:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25634 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaL2NCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:02:03 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-21-54a150c9ad36
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] dmaengine: k3: Fix duplicated function name and allmodconfig
 build
Date: Mon, 29 Dec 2014 14:01:30 +0100
Message-id: <1419858090-7682-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t/xa7onAxaGGGw6LWoxfeoFRovVU/+y
	Wrx+YWhxedccNoutm/YyW7zs28/iwObxZNNFRo/Fe14yefRtWcXo8XmTXABLFJdNSmpOZllq
	kb5dAldG2/8O9oK3vBUXVx9gbWB8xd3FyMkhIWAiMfHIR2YIW0ziwr31bCC2kMBSRomGu1Ig
	Nq+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGaK8j0li9sx8EJtNwFhi8/IlQGO4OEQE
	OhklPk4+yQrRkCqx5cMasPnCAqES51p3gNksAqoSD3++YIfY5Sbx7slPJoh75CROHpvMOoGR
	bxaSM2YhnDELyRkLGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE5tcdjEuPWR1iFOBg
	VOLhTTixIESINbGsuDL3EKMEB7OSCK+05cIQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyT/7Ye
	PnHgiLLEpVe+097/arwue0vgJ8fh2VWmqUpeG/c/zfNnUp7fNr1Q81lm9/mF79cKKCQrmrkn
	Lnxl/H2y9MTZobaxlsYXPm4/um/nY37bMDFjmfvlB97FBAuu/H74rgTDx3mJH7esTfha1LhK
	du/mpnNHJf8fL7r322wJn2et9OxtriezlViKMxINtZiLihMBsPpLjisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While splitting device control in db08425ebd51 ("dmaengine: k3:
Split device_control") new function with the same 'k3_dma_resume' name
was added, leading to build error:

drivers/dma/k3dma.c:823:12: error: conflicting types for ‘k3_dma_resume’
drivers/dma/k3dma.c:625:12: note: previous definition of ‘k3_dma_resume’ was here

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/dma/k3dma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index 49be7f687c4c..a4ff7e9e68be 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -601,7 +601,7 @@ static int k3_dma_terminate_all(struct dma_chan *chan)
 	return 0;
 }
 
-static int k3_dma_pause(struct dma_chan *chan)
+static int k3_dma_transfer_pause(struct dma_chan *chan)
 {
 	struct k3_dma_chan *c = to_k3_chan(chan);
 	struct k3_dma_dev *d = to_k3_dma(chan->device);
@@ -622,7 +622,7 @@ static int k3_dma_pause(struct dma_chan *chan)
 	return 0;
 }
 
-static int k3_dma_resume(struct dma_chan *chan)
+static int k3_dma_transfer_resume(struct dma_chan *chan)
 {
 	struct k3_dma_chan *c = to_k3_chan(chan);
 	struct k3_dma_dev *d = to_k3_dma(chan->device);
@@ -735,8 +735,8 @@ static int k3_dma_probe(struct platform_device *op)
 	d->slave.device_prep_slave_sg = k3_dma_prep_slave_sg;
 	d->slave.device_issue_pending = k3_dma_issue_pending;
 	d->slave.device_config = k3_dma_config;
-	d->slave.device_pause = k3_dma_pause;
-	d->slave.device_resume = k3_dma_resume;
+	d->slave.device_pause = k3_dma_transfer_pause;
+	d->slave.device_resume = k3_dma_transfer_resume;
 	d->slave.device_terminate_all = k3_dma_terminate_all;
 	d->slave.copy_align = DMA_ALIGN;
 
-- 
1.9.1

