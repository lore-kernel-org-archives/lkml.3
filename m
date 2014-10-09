Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaJIRCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:02:21 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59012 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaJIRCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:02:15 -0400
From: Tsung-Han Lin <tsunghan.tw@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: correct coding style errors
Date: Fri, 10 Oct 2014 01:02:02 +0800
Message-Id: <1412874122-7650-1-git-send-email-tsunghan.tw@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct some coding style errors in
drivers/staging/rtl8192u/r819xU_firmware.c.

Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
---
 drivers/staging/rtl8192u/r819xU_firmware.c | 65 +++++++++++++++---------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index f66ad8a0dfe0..4c766ab3547e 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -37,7 +37,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 	bool		    rt_status = true;
 	u16		    frag_threshold;
 	u16		    frag_length, frag_offset = 0;
-	//u16		    total_size;
+	/* u16		    total_size; */
 	int		    i;
 
 	rt_firmware	    *pfirmware = priv->pFirmware;
@@ -47,7 +47,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 	u8                  bLastIniPkt;
 
 	firmware_init_param(dev);
-	//Fragmentation might be required
+	/* Fragmentation might be required */
 	frag_threshold = pfirmware->cmdpacket_frag_thresold;
 	do {
 		if ((buffer_len - frag_offset) > frag_threshold) {
@@ -66,7 +66,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		skb  = dev_alloc_skb(USB_HWDESC_HEADER_LEN + frag_length + 4);
 		if (!skb)
 			return false;
-		memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
+		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
 		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
@@ -78,19 +78,19 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		 * Transform from little endian to big endian
 		 * and pending  zero
 		 */
-		for (i=0; i < frag_length; i+=4) {
-			*seg_ptr++ = ((i+0)<frag_length)?code_virtual_address[i+3]:0;
-			*seg_ptr++ = ((i+1)<frag_length)?code_virtual_address[i+2]:0;
-			*seg_ptr++ = ((i+2)<frag_length)?code_virtual_address[i+1]:0;
-			*seg_ptr++ = ((i+3)<frag_length)?code_virtual_address[i+0]:0;
+		for (i = 0; i < frag_length; i += 4) {
+			*seg_ptr++ = ((i+0) < frag_length)?code_virtual_address[i+3]:0;
+			*seg_ptr++ = ((i+1) < frag_length)?code_virtual_address[i+2]:0;
+			*seg_ptr++ = ((i+2) < frag_length)?code_virtual_address[i+1]:0;
+			*seg_ptr++ = ((i+3) < frag_length)?code_virtual_address[i+0]:0;
 		}
-		tcb_desc->txbuf_size= (u16)i;
+		tcb_desc->txbuf_size = (u16)i;
 		skb_put(skb, i);
 
-		if (!priv->ieee80211->check_nic_enough_desc(dev,tcb_desc->queue_index)||
-			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index]))||\
+		if (!priv->ieee80211->check_nic_enough_desc(dev, tcb_desc->queue_index) ||
+			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index])) || \
 			(priv->ieee80211->queue_stop)) {
-			RT_TRACE(COMP_FIRMWARE,"=====================================================> tx full!\n");
+			RT_TRACE(COMP_FIRMWARE, "=====================================================> tx full!\n");
 			skb_queue_tail(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index], skb);
 		} else {
 			priv->ieee80211->softmac_hard_start_xmit(skb, dev);
@@ -105,19 +105,20 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 
 }
 
-//-----------------------------------------------------------------------------
-// Procedure:    Check whether main code is download OK. If OK, turn on CPU
-//
-// Description:   CPU register locates in different page against general register.
-//			    Switch to CPU register in the begin and switch back before return
-//
-//
-// Arguments:   The pointer of the adapter
-//
-// Returns:
-//        NDIS_STATUS_FAILURE - the following initialization process should be terminated
-//        NDIS_STATUS_SUCCESS - if firmware initialization process success
-//-----------------------------------------------------------------------------
+/*-----------------------------------------------------------------------------
+ * Procedure:    Check whether main code is download OK. If OK, turn on CPU
+ *
+ * Description:   CPU register locates in different page against general register.
+ *			    Switch to CPU register in the begin and switch back before return
+ *
+ *
+ * Arguments:   The pointer of the adapter
+ *
+ * Returns:
+ *        NDIS_STATUS_FAILURE - the following initialization process should be terminated
+ *        NDIS_STATUS_SUCCESS - if firmware initialization process success
+ *-----------------------------------------------------------------------------
+ */
 static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
 {
 	bool		rt_status = true;
@@ -220,7 +221,7 @@ bool init_firmware(struct net_device *dev)
 		/* it is called by reset */
 		rst_opt = OPT_SYSTEM_RESET;
 		starting_state = FW_INIT_STEP0_BOOT;
-		// TODO: system reset
+		/* TODO: system reset */
 
 	} else if (pfirmware->firmware_status == FW_STATUS_5_READY) {
 		/* it is called by Initialize */
@@ -240,7 +241,7 @@ bool init_firmware(struct net_device *dev)
 		 * or read image file from array. Default load from IMG file
 		 */
 		if (rst_opt == OPT_SYSTEM_RESET) {
-			rc = request_firmware(&fw_entry, fw_name[init_step],&priv->udev->dev);
+			rc = request_firmware(&fw_entry, fw_name[init_step], &priv->udev->dev);
 			if (rc < 0) {
 				RT_TRACE(COMP_ERR, "request firmware fail!\n");
 				goto download_firmware_fail;
@@ -252,12 +253,12 @@ bool init_firmware(struct net_device *dev)
 			}
 
 			if (init_step != FW_INIT_STEP1_MAIN) {
-				memcpy(pfirmware->firmware_buf,fw_entry->data,fw_entry->size);
+				memcpy(pfirmware->firmware_buf, fw_entry->data, fw_entry->size);
 				mapped_file = pfirmware->firmware_buf;
 				file_length = fw_entry->size;
 			} else {
 				memset(pfirmware->firmware_buf, 0, 128);
-				memcpy(&pfirmware->firmware_buf[128],fw_entry->data,fw_entry->size);
+				memcpy(&pfirmware->firmware_buf[128], fw_entry->data, fw_entry->size);
 				mapped_file = pfirmware->firmware_buf;
 				file_length = fw_entry->size + 128;
 			}
@@ -289,7 +290,7 @@ bool init_firmware(struct net_device *dev)
 			 * will set polling bit when firmware code is also configured
 			 */
 			pfirmware->firmware_status = FW_STATUS_1_MOVE_BOOT_CODE;
-			//mdelay(1000);
+			/* mdelay(1000); */
 			/*
 			 * To initialize IMEM, CPU move code  from 0x80000080,
 			 * hence, we send 0x80 byte packet
@@ -317,7 +318,7 @@ bool init_firmware(struct net_device *dev)
 
 			rt_status = CPUcheck_firmware_ready(dev);
 			if (rt_status != TRUE) {
-				RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n",rt_status);
+				RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n", rt_status);
 				goto download_firmware_fail;
 			}
 
@@ -328,7 +329,7 @@ bool init_firmware(struct net_device *dev)
 	}
 
 	RT_TRACE(COMP_FIRMWARE, "Firmware Download Success\n");
-	//assert(pfirmware->firmware_status == FW_STATUS_5_READY, ("Firmware Download Fail\n"));
+	/* assert(pfirmware->firmware_status == FW_STATUS_5_READY, ("Firmware Download Fail\n")); */
 
 	return rt_status;
 
-- 
1.9.1

