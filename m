Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaIDP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:28:44 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:46611 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750882AbaIDP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:28:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3653:3865:3866:3867:3868:3870:3871:3872:4050:4119:4250:4321:5007:6119:7514:7652:7875:7903:8603:8829:8957:9040:10004:10848:11026:11232:11473:11658:11914:12043:12291:12294:12295:12296:12438:12517:12519:12555:12683:12740:13255:13868:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: copy21_4b523f240cb63
X-Filterd-Recvd-Size: 8580
Message-ID: <1409844514.2770.6.camel@joe-AO725>
Subject: Re: [PATCH] Staging: rtl8192u: fix brace style coding issue in
 r819xU_firmware.c
From: Joe Perches <joe@perches.com>
To: Chaitra Ramaiah <linux.delve@gmail.com>
Cc: gregkh@linuxfoundation.org, burzalodowa@gmail.com, anarey@gmail.com,
        rmfrfs@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 08:28:34 -0700
In-Reply-To: <1409843463-3702-2-git-send-email-linux.delve@gmail.com>
References: <1409843463-3702-1-git-send-email-linux.delve@gmail.com>
	 <1409843463-3702-2-git-send-email-linux.delve@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 20:41 +0530, Chaitra Ramaiah wrote:
> Signed-off-by: Chaitra Ramaiah <linux.delve@gmail.com>

Please put the commit log description from your
cover letter into this patch submission and only
send 1 email instead of than 2.

Rather than add these one-line-at-a-time type changes,
I'd just as soon see these all corrected at the same
time using something like this below.

It also allows git diff -w to be shown as empty in a
commit log and this should be verified before and after
as compilable with no changes using scripts/objdiff.

$ ./scripts/checkpatch.pl --fix-inplace --types=spacing --strict -f drivers/staging/rtl8192u/r819xU_firmware.c
$ git diff --stat -p drivers/staging/rtl8192u/r819xU_firmware.c
 drivers/staging/rtl8192u/r819xU_firmware.c | 52 +++++++++++++++---------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 671cbe6..8e116f8 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -51,7 +51,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 	frag_threshold = pfirmware->cmdpacket_frag_thresold;
 	do {
 		if ((buffer_len - frag_offset) > frag_threshold) {
-			frag_length = frag_threshold ;
+			frag_length = frag_threshold;
 			bLastIniPkt = 0;
 
 		} else {
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
-		for(i=0 ; i < frag_length; i+=4) {
-			*seg_ptr++ = ((i+0)<frag_length)?code_virtual_address[i+3]:0;
-			*seg_ptr++ = ((i+1)<frag_length)?code_virtual_address[i+2]:0;
-			*seg_ptr++ = ((i+2)<frag_length)?code_virtual_address[i+1]:0;
-			*seg_ptr++ = ((i+3)<frag_length)?code_virtual_address[i+0]:0;
+		for (i = 0 ; i < frag_length; i += 4) {
+			*seg_ptr++ = ((i+0) < frag_length) ? code_virtual_address[i+3] : 0;
+			*seg_ptr++ = ((i+1) < frag_length) ? code_virtual_address[i+2] : 0;
+			*seg_ptr++ = ((i+2) < frag_length) ? code_virtual_address[i+1] : 0;
+			*seg_ptr++ = ((i+3) < frag_length) ? code_virtual_address[i+0] : 0;
 		}
-		tcb_desc->txbuf_size= (u16)i;
+		tcb_desc->txbuf_size = (u16)i;
 		skb_put(skb, i);
 
-		if (!priv->ieee80211->check_nic_enough_desc(dev,tcb_desc->queue_index)||
-			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index]))||\
-			(priv->ieee80211->queue_stop) ) {
-			RT_TRACE(COMP_FIRMWARE,"=====================================================> tx full!\n");
+		if (!priv->ieee80211->check_nic_enough_desc(dev, tcb_desc->queue_index) || 
+			(!skb_queue_empty(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index])) || \
+			(priv->ieee80211->queue_stop)) {
+			RT_TRACE(COMP_FIRMWARE, "=====================================================> tx full!\n");
 			skb_queue_tail(&priv->ieee80211->skb_waitQ[tcb_desc->queue_index], skb);
 		} else {
 			priv->ieee80211->softmac_hard_start_xmit(skb, dev);
@@ -99,7 +99,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		code_virtual_address += frag_length;
 		frag_offset += frag_length;
 
-	}while(frag_offset < buffer_len);
+	} while (frag_offset < buffer_len);
 
 	return rt_status;
 
@@ -131,7 +131,7 @@ static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
 		if (CPU_status&CPU_GEN_PUT_CODE_OK)
 			break;
 
-	}while(check_putcodeOK_time--);
+	} while (check_putcodeOK_time--);
 
 	if (!(CPU_status&CPU_GEN_PUT_CODE_OK)) {
 		RT_TRACE(COMP_ERR, "Download Firmware: Put code fail!\n");
@@ -151,7 +151,7 @@ static bool CPUcheck_maincodeok_turnonCPU(struct net_device *dev)
 
 		if (CPU_status&CPU_GEN_BOOT_RDY)
 			break;
-	}while(check_bootOk_time--);
+	} while (check_bootOk_time--);
 
 	if (!(CPU_status&CPU_GEN_BOOT_RDY)) {
 		goto CPUCheckMainCodeOKAndTurnOnCPU_Fail;
@@ -181,7 +181,7 @@ static bool CPUcheck_firmware_ready(struct net_device *dev)
 		if (CPU_status&CPU_GEN_FIRM_RDY)
 			break;
 
-	}while(check_time--);
+	} while (check_time--);
 
 	if (!(CPU_status&CPU_GEN_FIRM_RDY))
 		goto CPUCheckFirmwareReady_Fail;
@@ -217,17 +217,17 @@ bool init_firmware(struct net_device *dev)
 
 	RT_TRACE(COMP_FIRMWARE, " PlatformInitFirmware()==>\n");
 
-	if (pfirmware->firmware_status == FW_STATUS_0_INIT ) {
+	if (pfirmware->firmware_status == FW_STATUS_0_INIT) {
 		/* it is called by reset */
 		rst_opt = OPT_SYSTEM_RESET;
 		starting_state = FW_INIT_STEP0_BOOT;
 		// TODO: system reset
 
-	}else if (pfirmware->firmware_status == FW_STATUS_5_READY) {
+	} else if (pfirmware->firmware_status == FW_STATUS_5_READY) {
 		/* it is called by Initialize */
 		rst_opt = OPT_FIRMWARE_RESET;
 		starting_state = FW_INIT_STEP2_DATA;
-	}else {
+	} else {
 		 RT_TRACE(COMP_FIRMWARE, "PlatformInitFirmware: undefined firmware state\n");
 	}
 
@@ -235,14 +235,14 @@ bool init_firmware(struct net_device *dev)
 	 * Download boot, main, and data image for System reset.
 	 * Download data image for firmware reset
 	 */
-	for(init_step = starting_state; init_step <= FW_INIT_STEP2_DATA; init_step++) {
+	for (init_step = starting_state; init_step <= FW_INIT_STEP2_DATA; init_step++) {
 		/*
 		 * Open image file, and map file to continuous memory if open file success.
 		 * or read image file from array. Default load from IMG file
 		 */
 		if (rst_opt == OPT_SYSTEM_RESET) {
-			rc = request_firmware(&fw_entry, fw_name[init_step],&priv->udev->dev);
-			if (rc < 0 ) {
+			rc = request_firmware(&fw_entry, fw_name[init_step], &priv->udev->dev);
+			if (rc < 0) {
 				RT_TRACE(COMP_ERR, "request firmware fail!\n");
 				goto download_firmware_fail;
 			}
@@ -253,17 +253,17 @@ bool init_firmware(struct net_device *dev)
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
 			pfirmware->firmware_buf_size = file_length;
-		}else if (rst_opt == OPT_FIRMWARE_RESET ) {
+		} else if (rst_opt == OPT_FIRMWARE_RESET) {
 			/* we only need to download data.img here */
 			mapped_file = pfirmware->firmware_buf;
 			file_length = pfirmware->firmware_buf_size;
@@ -318,7 +318,7 @@ bool init_firmware(struct net_device *dev)
 
 			rt_status = CPUcheck_firmware_ready(dev);
 			if (rt_status != TRUE) {
-				RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n",rt_status);
+				RT_TRACE(COMP_ERR, "CPUcheck_firmware_ready fail(%d)!\n", rt_status);
 				goto download_firmware_fail;
 			}
 


