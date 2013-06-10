Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3FJFFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 01:05:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57456 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3FJFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 01:05:22 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: keith.busch@intel.com, vishal.l.verma@linux.intel.com,
        matthew.r.wilcox@intel.com
Subject: [PATCH] NVMe: Use kzalloc instead of kmalloc+memset
Date: Mon, 10 Jun 2013 10:20:55 +0530
Message-Id: <1370839855-1357-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc instead of kmalloc and a susbsequent memset.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/block/nvme-scsi.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index fed54b0..51d39a0 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -934,13 +934,12 @@ static int nvme_trans_bdev_char_page(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	int res = SNTI_TRANSLATION_SUCCESS;
 	int xfer_len;
 
-	inq_response = kmalloc(EXTENDED_INQUIRY_DATA_PAGE_LENGTH, GFP_KERNEL);
+	inq_response = kzalloc(EXTENDED_INQUIRY_DATA_PAGE_LENGTH, GFP_KERNEL);
 	if (inq_response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
 
-	memset(inq_response, 0, EXTENDED_INQUIRY_DATA_PAGE_LENGTH);
 	inq_response[1] = INQ_BDEV_CHARACTERISTICS_PAGE;    /* Page Code */
 	inq_response[2] = 0x00;    /* Page Length MSB */
 	inq_response[3] = 0x3C;    /* Page Length LSB */
@@ -965,12 +964,11 @@ static int nvme_trans_log_supp_pages(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	int xfer_len;
 	u8 *log_response;
 
-	log_response = kmalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH, GFP_KERNEL);
+	log_response = kzalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH, GFP_KERNEL);
 	if (log_response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
-	memset(log_response, 0, LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH);
 
 	log_response[0] = LOG_PAGE_SUPPORTED_LOG_PAGES_PAGE;
 	/* Subpage=0x00, Page Length MSB=0 */
@@ -1001,12 +999,11 @@ static int nvme_trans_log_info_exceptions(struct nvme_ns *ns,
 	u8 temp_c;
 	u16 temp_k;
 
-	log_response = kmalloc(LOG_INFO_EXCP_PAGE_LENGTH, GFP_KERNEL);
+	log_response = kzalloc(LOG_INFO_EXCP_PAGE_LENGTH, GFP_KERNEL);
 	if (log_response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
-	memset(log_response, 0, LOG_INFO_EXCP_PAGE_LENGTH);
 
 	mem = dma_alloc_coherent(&dev->pci_dev->dev,
 					sizeof(struct nvme_smart_log),
@@ -1070,12 +1067,11 @@ static int nvme_trans_log_temperature(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	u8 temp_c_cur, temp_c_thresh;
 	u16 temp_k;
 
-	log_response = kmalloc(LOG_TEMP_PAGE_LENGTH, GFP_KERNEL);
+	log_response = kzalloc(LOG_TEMP_PAGE_LENGTH, GFP_KERNEL);
 	if (log_response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
-	memset(log_response, 0, LOG_TEMP_PAGE_LENGTH);
 
 	mem = dma_alloc_coherent(&dev->pci_dev->dev,
 					sizeof(struct nvme_smart_log),
@@ -1381,12 +1377,11 @@ static int nvme_trans_mode_page_create(struct nvme_ns *ns,
 	blk_desc_offset = mph_size;
 	mode_pages_offset_1 = blk_desc_offset + blk_desc_len;
 
-	response = kmalloc(resp_size, GFP_KERNEL);
+	response = kzalloc(resp_size, GFP_KERNEL);
 	if (response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
-	memset(response, 0, resp_size);
 
 	res = nvme_trans_fill_mode_parm_hdr(&response[0], mph_size, cdb10,
 					llbaa, mode_data_length, blk_desc_len);
@@ -2481,12 +2476,11 @@ static int nvme_trans_read_capacity(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	}
 	id_ns = mem;
 
-	response = kmalloc(resp_size, GFP_KERNEL);
+	response = kzalloc(resp_size, GFP_KERNEL);
 	if (response == NULL) {
 		res = -ENOMEM;
 		goto out_dma;
 	}
-	memset(response, 0, resp_size);
 	nvme_trans_fill_read_cap(response, id_ns, cdb16);
 
 	xfer_len = min(alloc_len, resp_size);
@@ -2555,12 +2549,11 @@ static int nvme_trans_report_luns(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 			goto out_dma;
 		}
 
-		response = kmalloc(resp_size, GFP_KERNEL);
+		response = kzalloc(resp_size, GFP_KERNEL);
 		if (response == NULL) {
 			res = -ENOMEM;
 			goto out_dma;
 		}
-		memset(response, 0, resp_size);
 
 		/* The first LUN ID will always be 0 per the SAM spec */
 		for (lun_id = 0; lun_id < le32_to_cpu(id_ctrl->nn); lun_id++) {
@@ -2601,12 +2594,11 @@ static int nvme_trans_request_sense(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 
 	resp_size = ((desc_format) ? (DESC_FMT_SENSE_DATA_SIZE) :
 					(FIXED_FMT_SENSE_DATA_SIZE));
-	response = kmalloc(resp_size, GFP_KERNEL);
+	response = kzalloc(resp_size, GFP_KERNEL);
 	if (response == NULL) {
 		res = -ENOMEM;
 		goto out;
 	}
-	memset(response, 0, resp_size);
 
 	if (desc_format == DESCRIPTOR_FORMAT_SENSE_DATA_TYPE) {
 		/* Descriptor Format Sense Data */
-- 
1.7.9.5

