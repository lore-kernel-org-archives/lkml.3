Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3EMXEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:04:31 -0400
Received: from mail-ye0-f196.google.com ([209.85.213.196]:62441 "EHLO
	mail-ye0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:04:30 -0400
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 19:04:29 EDT
From: Dylan Socolobsky <dsocolobsky@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org,
        devendra.aaru@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dylan Socolobsky <dsocolobsky@gmail.com>
Subject: [PATCH 2/2] Staging: ft1000: Change C99 comments in ft1000_dnld.c
Date: Mon, 13 May 2013 19:47:33 -0300
Message-Id: <1368485253-8985-1-git-send-email-dsocolobsky@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch fixes the ERRORs found by checkpatch.pl in the file
ft1000_dnld.c by switching to the standard Kernel comment style.

Signed-off-by: Dylan Socolobsky <dsocolobsky@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 18a8751..f892598 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -132,16 +132,16 @@ void card_bootload(struct net_device *dev)
 	pdata = (u32 *) bootimage;
 	size = sizeof(bootimage);
 
-	// check for odd word
+	/* check for odd word */
 	if (size & 0x0003)
 		size += 4;
 
-	// Provide mutual exclusive access while reading ASIC registers.
+	/* Provide mutual exclusive access while reading ASIC registers. */
 	spin_lock_irqsave(&info->dpram_lock, flags);
 
-	// need to set i/o base address initially and hardware will autoincrement
+	/* need to set i/o base address initially and hardware will autoincrement */
 	ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, FT1000_DPRAM_BASE);
-	// write bytes
+	/* write bytes */
 	for (i = 0; i < (size >> 2); i++) {
 		templong = *pdata++;
 		outl(templong, dev->base_addr + FT1000_REG_MAG_DPDATA);
@@ -390,7 +390,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						Status = FAILURE;
 						break;
 					}
-					// Provide mutual exclusive access while reading ASIC registers.
+					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
 					/*
@@ -504,7 +504,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					break;
 
 				case REQUEST_MAILBOX_DATA:
-					// Convert length from byte count to word count. Make sure we round up.
+					/* Convert length from byte count to word count. Make sure we round up. */
 					word_length =
 						(long)(info->DSPInfoBlklen + 1) / 2;
 					put_request_value(dev, word_length);
@@ -512,7 +512,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						(struct drv_msg *) & info->DSPInfoBlk[0];
 					pUsData =
 						(u16 *) & pMailBoxData->data[0];
-					// Provide mutual exclusive access while reading ASIC registers.
+					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
 					if (file_version == 5) {
@@ -564,7 +564,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						(u16 *) ((long)pFileStart +
 							pFileHdr5->
 							version_data_offset);
-					// Provide mutual exclusive access while reading ASIC registers.
+					/* Provide mutual exclusive access while reading ASIC registers. */
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
 					/*
@@ -716,7 +716,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 				}
 				usHdrLength = ntohs(pHdr->length);	/* Byte length for PROV records */
 
-				// Get buffer for provisioning data
+				/* Get buffer for provisioning data */
 				pbuffer =
 					kmalloc((usHdrLength + sizeof(struct pseudo_hdr)),
 						GFP_ATOMIC);
@@ -724,7 +724,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 					memcpy(pbuffer, (void *)pUcFile,
 						   (u32) (usHdrLength +
 							   sizeof(struct pseudo_hdr)));
-					// link provisioning data
+					/* link provisioning data */
 					pprov_record =
 						kmalloc(sizeof(struct prov_record),
 							GFP_ATOMIC);
@@ -734,7 +734,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart,
 						list_add_tail(&pprov_record->
 								  list,
 								  &info->prov_list);
-						// Move to next entry if available
+						/* Move to next entry if available */
 						pUcFile =
 							(u8 *) ((unsigned long) pUcFile +
 								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
-- 
1.8.1.4

