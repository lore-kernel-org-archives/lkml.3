Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288Ab3GLSlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:41:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:42097 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab3GLSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <CE05A282.D8D9%vishal.l.verma@intel.com>
References: <1373642209-16288-1-git-send-email-alexj@rosedu.org> <CE05A282.D8D9%vishal.l.verma@intel.com>
From: Alexandru Juncu <alexj@rosedu.org>
Date: Fri, 12 Jul 2013 21:40:59 +0300
X-Google-Sender-Auth: QCuKjZm9Br8p8s-XE2hP598vEMs
Message-ID: <CAPhGq=ayjbAF4fkGBGheM6jXU8DtE7HeOgSfMLqgOaAj-XRt0Q@mail.gmail.com>
Subject: Re: [PATCH] NVMe: replace kmalloc and memset with kzalloc.
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "willy@linux.intel.com" <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ok, thank you. Should have used newer repo.

On 12 July 2013 21:17, Verma, Vishal L <vishal.l.verma@intel.com> wrote:
> Hi Alexandru,
>
> This patch has already been applied:
> http://git.infradead.org/users/willy/linux-nvme.git/commitdiff/03ea83e9a37e
> 41d436f8348e6eee3d8281bfff3a
>
>
> It was submitted on the LKML on 6/9 by Tushar Behera.
>
> Thanks,
> -Vishal
>
> On 7/12/13 9:16 AM, "Alexandru Juncu" <alexj@rosedu.org> wrote:
>
>>Found using coccinelle.
>>
>>Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
>>---
>> drivers/block/nvme-scsi.c | 24 ++++++++----------------
>> 1 file changed, 8 insertions(+), 16 deletions(-)
>>
>>diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
>>index 102de2f..4a4ff4e 100644
>>--- a/drivers/block/nvme-scsi.c
>>+++ b/drivers/block/nvme-scsi.c
>>@@ -933,13 +933,12 @@ static int nvme_trans_bdev_char_page(struct nvme_ns
>>*ns, struct sg_io_hdr *hdr,
>>       int res = SNTI_TRANSLATION_SUCCESS;
>>       int xfer_len;
>>
>>-      inq_response = kmalloc(EXTENDED_INQUIRY_DATA_PAGE_LENGTH, GFP_KERNEL);
>>+      inq_response = kzalloc(EXTENDED_INQUIRY_DATA_PAGE_LENGTH, GFP_KERNEL);
>>       if (inq_response == NULL) {
>>               res = -ENOMEM;
>>               goto out_mem;
>>       }
>>
>>-      memset(inq_response, 0, EXTENDED_INQUIRY_DATA_PAGE_LENGTH);
>>       inq_response[1] = INQ_BDEV_CHARACTERISTICS_PAGE;    /* Page Code */
>>       inq_response[2] = 0x00;    /* Page Length MSB */
>>       inq_response[3] = 0x3C;    /* Page Length LSB */
>>@@ -964,12 +963,11 @@ static int nvme_trans_log_supp_pages(struct nvme_ns
>>*ns, struct sg_io_hdr *hdr,
>>       int xfer_len;
>>       u8 *log_response;
>>
>>-      log_response = kmalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH, GFP_KERNEL);
>>+      log_response = kzalloc(LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH, GFP_KERNEL);
>>       if (log_response == NULL) {
>>               res = -ENOMEM;
>>               goto out_mem;
>>       }
>>-      memset(log_response, 0, LOG_PAGE_SUPPORTED_LOG_PAGES_LENGTH);
>>
>>       log_response[0] = LOG_PAGE_SUPPORTED_LOG_PAGES_PAGE;
>>       /* Subpage=0x00, Page Length MSB=0 */
>>@@ -1000,12 +998,11 @@ static int nvme_trans_log_info_exceptions(struct
>>nvme_ns *ns,
>>       u8 temp_c;
>>       u16 temp_k;
>>
>>-      log_response = kmalloc(LOG_INFO_EXCP_PAGE_LENGTH, GFP_KERNEL);
>>+      log_response = kzalloc(LOG_INFO_EXCP_PAGE_LENGTH, GFP_KERNEL);
>>       if (log_response == NULL) {
>>               res = -ENOMEM;
>>               goto out_mem;
>>       }
>>-      memset(log_response, 0, LOG_INFO_EXCP_PAGE_LENGTH);
>>
>>       mem = dma_alloc_coherent(&dev->pci_dev->dev,
>>                                       sizeof(struct nvme_smart_log),
>>@@ -1069,12 +1066,11 @@ static int nvme_trans_log_temperature(struct
>>nvme_ns *ns, struct sg_io_hdr *hdr,
>>       u8 temp_c_cur, temp_c_thresh;
>>       u16 temp_k;
>>
>>-      log_response = kmalloc(LOG_TEMP_PAGE_LENGTH, GFP_KERNEL);
>>+      log_response = kzalloc(LOG_TEMP_PAGE_LENGTH, GFP_KERNEL);
>>       if (log_response == NULL) {
>>               res = -ENOMEM;
>>               goto out_mem;
>>       }
>>-      memset(log_response, 0, LOG_TEMP_PAGE_LENGTH);
>>
>>       mem = dma_alloc_coherent(&dev->pci_dev->dev,
>>                                       sizeof(struct nvme_smart_log),
>>@@ -1380,12 +1376,11 @@ static int nvme_trans_mode_page_create(struct
>>nvme_ns *ns,
>>       blk_desc_offset = mph_size;
>>       mode_pages_offset_1 = blk_desc_offset + blk_desc_len;
>>
>>-      response = kmalloc(resp_size, GFP_KERNEL);
>>+      response = kzalloc(resp_size, GFP_KERNEL);
>>       if (response == NULL) {
>>               res = -ENOMEM;
>>               goto out_mem;
>>       }
>>-      memset(response, 0, resp_size);
>>
>>       res = nvme_trans_fill_mode_parm_hdr(&response[0], mph_size, cdb10,
>>                                       llbaa, mode_data_length, blk_desc_len);
>>@@ -2480,12 +2475,11 @@ static int nvme_trans_read_capacity(struct
>>nvme_ns *ns, struct sg_io_hdr *hdr,
>>       }
>>       id_ns = mem;
>>
>>-      response = kmalloc(resp_size, GFP_KERNEL);
>>+      response = kzalloc(resp_size, GFP_KERNEL);
>>       if (response == NULL) {
>>               res = -ENOMEM;
>>               goto out_dma;
>>       }
>>-      memset(response, 0, resp_size);
>>       nvme_trans_fill_read_cap(response, id_ns, cdb16);
>>
>>       xfer_len = min(alloc_len, resp_size);
>>@@ -2554,12 +2548,11 @@ static int nvme_trans_report_luns(struct nvme_ns
>>*ns, struct sg_io_hdr *hdr,
>>                       goto out_dma;
>>               }
>>
>>-              response = kmalloc(resp_size, GFP_KERNEL);
>>+              response = kzalloc(resp_size, GFP_KERNEL);
>>               if (response == NULL) {
>>                       res = -ENOMEM;
>>                       goto out_dma;
>>               }
>>-              memset(response, 0, resp_size);
>>
>>               /* The first LUN ID will always be 0 per the SAM spec */
>>               for (lun_id = 0; lun_id < le32_to_cpu(id_ctrl->nn); lun_id++) {
>>@@ -2600,12 +2593,11 @@ static int nvme_trans_request_sense(struct
>>nvme_ns *ns, struct sg_io_hdr *hdr,
>>
>>       resp_size = ((desc_format) ? (DESC_FMT_SENSE_DATA_SIZE) :
>>                                       (FIXED_FMT_SENSE_DATA_SIZE));
>>-      response = kmalloc(resp_size, GFP_KERNEL);
>>+      response = kzalloc(resp_size, GFP_KERNEL);
>>       if (response == NULL) {
>>               res = -ENOMEM;
>>               goto out;
>>       }
>>-      memset(response, 0, resp_size);
>>
>>       if (desc_format == DESCRIPTOR_FORMAT_SENSE_DATA_TYPE) {
>>               /* Descriptor Format Sense Data */
>>--
>>1.8.1.2
>>
>>
>>_______________________________________________
>>Linux-nvme mailing list
>>Linux-nvme@lists.infradead.org
>>http://merlin.infradead.org/mailman/listinfo/linux-nvme
>
