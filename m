Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab3FHIm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:42:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:44860 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3FHImW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:42:22 -0400
Message-ID: <1370680937.24531.18.camel@localhost.localdomain>
Subject: [PATCH] NVMe: Cocci spatch "kzalloc-simple.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 08 Jun 2013 10:42:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.2 (3.8.2-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.

The coccinelle spatch that created this patch is available in the linux
source tree at file://scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -934,13 +934,12 @@ static int nvme_trans_bdev_char_page(str
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
@@ -965,12 +964,12 @@ static int nvme_trans_log_supp_pages(str
 	int xfer_len;
 	u8 *log_response;
 
-	log_response = kmalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH, GFP_KERNEL);
+	log_response = kzalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH,
+			       GFP_KERNEL);
 	if (log_response == NULL) {
 		res = -ENOMEM;
 		goto out_mem;
 	}
-	memset(log_response, 0, LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH);
 
 	log_response[0] = LOG_PAGE_SUPPORTED_LOG_PAGES_PAGE;
 	/* Subpage=0x00, Page Length MSB=0 */
@@ -1001,12 +1000,11 @@ static int nvme_trans_log_info_exception
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
@@ -1070,12 +1068,11 @@ static int nvme_trans_log_temperature(st
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
@@ -1381,12 +1378,11 @@ static int nvme_trans_mode_page_create(s
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
@@ -2481,12 +2477,11 @@ static int nvme_trans_read_capacity(stru
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
@@ -2555,12 +2550,11 @@ static int nvme_trans_report_luns(struct
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
@@ -2601,12 +2595,11 @@ static int nvme_trans_request_sense(stru
 
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


