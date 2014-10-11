Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaJKQDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:03:09 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43713 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJKQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:03:07 -0400
From: Jonas Brunsgaard <jonas.brunsgaard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Brunsgaard <jonas.brunsgaard@gmail.com>
Subject: [PATCH] usb: atm: fix codestyle issues in
Date: Sat, 11 Oct 2014 18:02:48 +0200
Message-Id: <1413043368-24548-1-git-send-email-jonas.brunsgaard@gmail.com>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonas Brunsgaard <jonas.brunsgaard@gmail.com>
---
 drivers/usb/atm/ueagle-atm.c | 95 ++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 5a45937..eedb217 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -173,10 +173,10 @@ struct uea_softc {
 	const struct firmware *dsp_firm;
 	struct urb *urb_int;
 
-	void (*dispatch_cmv) (struct uea_softc *, struct intr_pkt *);
-	void (*schedule_load_page) (struct uea_softc *, struct intr_pkt *);
-	int (*stat) (struct uea_softc *);
-	int (*send_cmvs) (struct uea_softc *);
+	void (*dispatch_cmv)(struct uea_softc *, struct intr_pkt *);
+	void (*schedule_load_page)(struct uea_softc *, struct intr_pkt *);
+	int (*stat)(struct uea_softc *);
+	int (*send_cmvs)(struct uea_softc *);
 
 	/* keep in sync with eaglectl */
 	struct uea_stats {
@@ -576,8 +576,7 @@ static int annex[NB_MODEM];
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "module debug level (0=off,1=on,2=verbose)");
 module_param_array(altsetting, uint, NULL, 0644);
-MODULE_PARM_DESC(altsetting, "alternate setting for incoming traffic: 0=bulk, "
-			     "1=isoc slowest, ... , 8=isoc fastest (default)");
+MODULE_PARM_DESC(altsetting, "alternate setting for incoming traffic: 0=bulk, 1=isoc slowest, ... , 8=isoc fastest (default)");
 module_param_array(sync_wait, bool, NULL, 0644);
 MODULE_PARM_DESC(sync_wait, "wait the synchronisation before starting ATM");
 module_param_array(cmv_file, charp, NULL, 0644);
@@ -686,8 +685,7 @@ static void uea_upload_pre_firmware(const struct firmware *fw_entry,
 
 		ret = uea_send_modem_cmd(usb, add, len, pfw + 3);
 		if (ret < 0) {
-			uea_err(usb, "uploading firmware data failed "
-					"with error %d\n", ret);
+			uea_err(usb, "uploading firmware data failed with error %d\n", ret);
 			goto err;
 		}
 		pfw += len + 3;
@@ -829,6 +827,7 @@ static int check_dsp_e4(const u8 *dsp, int len)
 	for (i = 0; i < E4_MAX_PAGE_NUMBER; i++) {
 		struct block_index *blockidx;
 		u8 blockno = p->page_number_to_block_index[i];
+
 		if (blockno >= E4_NO_SWAPPAGE_HEADERS)
 			continue;
 
@@ -1040,10 +1039,9 @@ static void __uea_load_page_e4(struct uea_softc *sc, u8 pageno, int boot)
 		bi.dwAddress = cpu_to_be32(le32_to_cpu(blockidx->PageAddress));
 
 		uea_dbg(INS_TO_USBDEV(sc),
-			"sending block %u for DSP page "
-			"%u size %u address %x\n",
-			blockno, pageno, blocksize,
-			le32_to_cpu(blockidx->PageAddress));
+				"sending block %u for DSP page %u size %u address %x\n",
+				blockno, pageno, blocksize,
+				le32_to_cpu(blockidx->PageAddress));
 
 		/* send block info through the IDMA pipe */
 		if (uea_idma_write(sc, &bi, E4_BLOCK_INFO_SIZE))
@@ -1060,7 +1058,6 @@ static void __uea_load_page_e4(struct uea_softc *sc, u8 pageno, int boot)
 
 bad:
 	uea_err(INS_TO_USBDEV(sc), "sending DSP block %u failed\n", blockno);
-	return;
 }
 
 static void uea_load_page_e4(struct work_struct *work)
@@ -1084,8 +1081,7 @@ static void uea_load_page_e4(struct work_struct *work)
 
 	p = (struct l1_code *) sc->dsp_firm->data;
 	if (pageno >= le16_to_cpu(p->page_header[0].PageNumber)) {
-		uea_err(INS_TO_USBDEV(sc), "invalid DSP "
-						"page %u requested\n", pageno);
+		uea_err(INS_TO_USBDEV(sc), "invalid DSP page %u requested\n", pageno);
 		return;
 	}
 
@@ -1180,8 +1176,8 @@ static int uea_cmv_e1(struct uea_softc *sc,
 	int ret;
 
 	uea_enters(INS_TO_USBDEV(sc));
-	uea_vdbg(INS_TO_USBDEV(sc), "Function : %d-%d, Address : %c%c%c%c, "
-			"offset : 0x%04x, data : 0x%08x\n",
+	uea_vdbg(INS_TO_USBDEV(sc),
+			"Function : %d-%d, Address : %c%c%c%c, offset : 0x%04x, data : 0x%08x\n",
 			E1_FUNCTION_TYPE(function),
 			E1_FUNCTION_SUBTYPE(function),
 			E1_GETSA1(address), E1_GETSA2(address),
@@ -1220,10 +1216,10 @@ static int uea_cmv_e4(struct uea_softc *sc,
 	uea_enters(INS_TO_USBDEV(sc));
 	memset(&cmv, 0, sizeof(cmv));
 
-	uea_vdbg(INS_TO_USBDEV(sc), "Function : %d-%d, Group : 0x%04x, "
-		 "Address : 0x%04x, offset : 0x%04x, data : 0x%08x\n",
-		 E4_FUNCTION_TYPE(function), E4_FUNCTION_SUBTYPE(function),
-		 group, address, offset, data);
+	uea_vdbg(INS_TO_USBDEV(sc),
+			"Function : %d-%d, Group : 0x%04x, Address : 0x%04x, offset : 0x%04x, data : 0x%08x\n",
+			E4_FUNCTION_TYPE(function), E4_FUNCTION_SUBTYPE(function),
+			group, address, offset, data);
 
 	/* we send a request, but we expect a reply */
 	sc->cmv_dsc.e4.function = function | (0x1 << 4);
@@ -1359,8 +1355,7 @@ static int uea_stat_e1(struct uea_softc *sc)
 		break;
 
 	case 3:		/* fail ... */
-		uea_info(INS_TO_USBDEV(sc), "modem synchronization failed"
-					" (may be try other cmv/dsp)\n");
+		uea_info(INS_TO_USBDEV(sc), "modem synchronization failed (may be try other cmv/dsp)\n");
 		return -EAGAIN;
 
 	case 4 ... 6:	/* test state */
@@ -1493,8 +1488,7 @@ static int uea_stat_e4(struct uea_softc *sc)
 	case 0x1:
 	case 0x3:
 	case 0x4:
-		uea_dbg(INS_TO_USBDEV(sc), "modem not yet "
-						"synchronized\n");
+		uea_dbg(INS_TO_USBDEV(sc), "modem not yet synchronized\n");
 		return 0;
 	case 0x5:	/* initialization */
 	case 0x6:
@@ -1503,8 +1497,7 @@ static int uea_stat_e4(struct uea_softc *sc)
 		uea_dbg(INS_TO_USBDEV(sc), "modem initializing\n");
 		return 0;
 	case 0x2:	/* fail ... */
-		uea_info(INS_TO_USBDEV(sc), "modem synchronization "
-				"failed (may be try other cmv/dsp)\n");
+		uea_info(INS_TO_USBDEV(sc), "modem synchronization failed (may be try other cmv/dsp)\n");
 		return -EAGAIN;
 	case 0x7:	/* operational */
 		break;
@@ -1667,9 +1660,9 @@ static int request_cmvs(struct uea_softc *sc,
 	if (ret < 0) {
 		/* if caller can handle old version, try to provide it */
 		if (*ver == 1) {
-			uea_warn(INS_TO_USBDEV(sc), "requesting "
-							"firmware %s failed, "
-				"try to get older cmvs\n", cmv_name);
+			uea_warn(INS_TO_USBDEV(sc),
+					"requesting firmware %s failed, try to get older cmvs\n",
+					cmv_name);
 			return request_cmvs_old(sc, cmvs, fw);
 		}
 		uea_err(INS_TO_USBDEV(sc),
@@ -1682,8 +1675,7 @@ static int request_cmvs(struct uea_softc *sc,
 	data = (u8 *) (*fw)->data;
 	if (size < 4 || strncmp(data, "cmv2", 4) != 0) {
 		if (*ver == 1) {
-			uea_warn(INS_TO_USBDEV(sc), "firmware %s is corrupted,"
-				" try to get older cmvs\n", cmv_name);
+			uea_warn(INS_TO_USBDEV(sc), "firmware %s is corrupted, try to get older cmvs\n", cmv_name);
 			release_firmware(*fw);
 			return request_cmvs_old(sc, cmvs, fw);
 		}
@@ -1743,8 +1735,7 @@ static int uea_send_cmvs_e1(struct uea_softc *sc)
 	if (ver == 1) {
 		struct uea_cmvs_v1 *cmvs_v1 = cmvs_ptr;
 
-		uea_warn(INS_TO_USBDEV(sc), "use deprecated cmvs version, "
-			"please update your firmware\n");
+		uea_warn(INS_TO_USBDEV(sc), "use deprecated cmvs version, please update your firmware\n");
 
 		for (i = 0; i < len; i++) {
 			ret = uea_write_cmv_e1(sc,
@@ -1774,8 +1765,7 @@ static int uea_send_cmvs_e1(struct uea_softc *sc)
 	/* Enter in R-ACT-REQ */
 	ret = uea_write_cmv_e1(sc, E1_SA_CNTL, 0, 2);
 	uea_vdbg(INS_TO_USBDEV(sc), "Entering in R-ACT-REQ state\n");
-	uea_info(INS_TO_USBDEV(sc), "modem started, waiting "
-						"synchronization...\n");
+	uea_info(INS_TO_USBDEV(sc), "modem started, waiting synchronization...\n");
 out:
 	release_firmware(cmvs_fw);
 	return ret;
@@ -1829,8 +1819,8 @@ static int uea_send_cmvs_e4(struct uea_softc *sc)
 	/* Enter in R-ACT-REQ */
 	ret = uea_write_cmv_e4(sc, 1, E4_SA_CNTL, 0, 0, 2);
 	uea_vdbg(INS_TO_USBDEV(sc), "Entering in R-ACT-REQ state\n");
-	uea_info(INS_TO_USBDEV(sc), "modem started, waiting "
-						"synchronization...\n");
+	uea_info(INS_TO_USBDEV(sc),
+			"modem started, waiting synchronization...\n");
 out:
 	release_firmware(cmvs_fw);
 	return ret;
@@ -1993,8 +1983,7 @@ static int load_XILINX_firmware(struct uea_softc *sc)
 	value = 0;
 	ret = uea_send_modem_cmd(sc->usb_dev, 0xe, 1, &value);
 	if (ret < 0)
-		uea_err(sc->usb_dev, "elsa de-assert failed with error"
-								" %d\n", ret);
+		uea_err(sc->usb_dev, "elsa de-assert failed with error %d\n", ret);
 
 err1:
 	release_firmware(fw_entry);
@@ -2051,16 +2040,16 @@ static void uea_dispatch_cmv_e1(struct uea_softc *sc, struct intr_pkt *intr)
 	return;
 
 bad2:
-	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received, "
-			"Function : %d, Subfunction : %d\n",
+	uea_err(INS_TO_USBDEV(sc),
+			"unexpected cmv received Function : %d, Subfunction : %d\n",
 			E1_FUNCTION_TYPE(cmv->bFunction),
 			E1_FUNCTION_SUBTYPE(cmv->bFunction));
 	uea_leaves(INS_TO_USBDEV(sc));
 	return;
 
 bad1:
-	uea_err(INS_TO_USBDEV(sc), "invalid cmv received, "
-			"wPreamble %d, bDirection %d\n",
+	uea_err(INS_TO_USBDEV(sc),
+			"invalid cmv received, wPreamble %d, bDirection %d\n",
 			le16_to_cpu(cmv->wPreamble), cmv->bDirection);
 	uea_leaves(INS_TO_USBDEV(sc));
 }
@@ -2100,12 +2089,11 @@ static void uea_dispatch_cmv_e4(struct uea_softc *sc, struct intr_pkt *intr)
 	return;
 
 bad2:
-	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received, "
-			"Function : %d, Subfunction : %d\n",
+	uea_err(INS_TO_USBDEV(sc),
+			"unexpected cmv received, Function : %d, Subfunction : %d\n",
 			E4_FUNCTION_TYPE(cmv->wFunction),
 			E4_FUNCTION_SUBTYPE(cmv->wFunction));
 	uea_leaves(INS_TO_USBDEV(sc));
-	return;
 }
 
 static void uea_schedule_load_page_e1(struct uea_softc *sc,
@@ -2250,6 +2238,7 @@ err0:
 static void uea_stop(struct uea_softc *sc)
 {
 	int ret;
+
 	uea_enters(INS_TO_USBDEV(sc));
 	ret = kthread_stop(sc->kthread);
 	uea_dbg(INS_TO_USBDEV(sc), "kthread finish with status %d\n", ret);
@@ -2454,10 +2443,11 @@ UEA_ATTR(firmid, 0);
 
 /* Retrieve the device End System Identifier (MAC) */
 
-static int uea_getesi(struct uea_softc *sc, u_char * esi)
+static int uea_getesi(struct uea_softc *sc, u_char *esi)
 {
 	unsigned char mac_str[2 * ETH_ALEN + 1];
 	int i;
+
 	if (usb_string
 	    (sc->usb_dev, sc->usb_dev->descriptor.iSerialNumber, mac_str,
 	     sizeof(mac_str)) != 2 * ETH_ALEN)
@@ -2561,10 +2551,9 @@ static int uea_bind(struct usbatm_data *usbatm, struct usb_interface *intf,
 	}
 
 	sc = kzalloc(sizeof(struct uea_softc), GFP_KERNEL);
-	if (!sc) {
-		uea_err(usb, "uea_init: not enough memory !\n");
+	if (!sc)
 		return -ENOMEM;
-	}
+
 
 	sc->usb_dev = usb;
 	usbatm->driver_data = sc;
@@ -2595,8 +2584,7 @@ static int uea_bind(struct usbatm_data *usbatm, struct usb_interface *intf,
 			uea_info(usb, "using iso mode\n");
 			usbatm->flags |= UDSL_USE_ISOC | UDSL_IGNORE_EILSEQ;
 		} else {
-			uea_err(usb, "setting alternate %u failed for "
-					"2 interface, using bulk mode\n", alt);
+			uea_err(usb, "setting alternate %u failed for 2 interface, using bulk mode\n", alt);
 		}
 	}
 
@@ -2673,6 +2661,7 @@ static void uea_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
 	int ifnum = intf->altsetting->desc.bInterfaceNumber;
+
 	uea_enters(usb);
 
 	/* ADI930 has 2 interfaces and eagle 3 interfaces.
-- 
1.9.3 (Apple Git-50)

