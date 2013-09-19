Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3ISWBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:01:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:57470 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab3ISWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:21 -0400
Subject: [PATCH 1/2] NVMe: Cocci spatch "kzalloc-simple"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604510863-2133994021-1-diffsplit-thomas@m3y3r.de>
References: <1379604510863-816646221-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604510863-816646221-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle spatch "api/alloc/kzalloc-simple.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -933,13 +933,12 @@ static int nvme_trans_bdev_char_page(str
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
@@ -964,12 +963,12 @@ static int nvme_trans_log_supp_pages(str
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
@@ -1000,12 +999,11 @@ static int nvme_trans_log_info_exception
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
@@ -1069,12 +1067,11 @@ static int nvme_trans_log_temperature(st
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
@@ -1380,12 +1377,11 @@ static int nvme_trans_mode_page_create(s
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
@@ -2480,12 +2476,11 @@ static int nvme_trans_read_capacity(stru
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
@@ -2554,12 +2549,11 @@ static int nvme_trans_report_luns(struct
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
@@ -2600,12 +2594,11 @@ static int nvme_trans_request_sense(stru
 
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
