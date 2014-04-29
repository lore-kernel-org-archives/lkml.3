Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaD2CRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:17:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38175 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbaD2CRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:17:48 -0400
X-Sasl-enc: 3f3UiLre0rY2Jx5FKwKrs359exKUyyFyK9vOEMY/Xbog 1398737862
Message-ID: <535F0BA3.9060601@fastmail.fm>
Date: Tue, 29 Apr 2014 10:17:07 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/10] staging: gdm72xx: Removed commented-out code
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed commented-out code

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.h   | 17 -----------------
 drivers/staging/gdm72xx/gdm_wimax.c |  4 ----
 drivers/staging/gdm72xx/gdm_wimax.h |  6 ------
 drivers/staging/gdm72xx/usb_boot.c  | 17 +----------------
 4 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
index 8f18119..6543cff 100644
--- a/drivers/staging/gdm72xx/gdm_qos.h
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -34,23 +34,6 @@
 #define	IEEE802_1QVLANID		0x10
 
 struct gdm_wimax_csr_s {
-	/*	union{
-		U16 all;
-		struct _CS_CLASSIFIER_RULE_ENABLE{
-			IPTypeOfService:1,
-			Protocol:1,
-			IPMaskedSrcAddress:1,
-			IPMaskedDstAddress:1,
-			ProtocolSrcPortRange:1,
-			ProtocolDstPortRange:1,
-			DstMacAddr:1,
-			SrcMacAddr:1,
-			Ethertype:1,
-			IEEE802_1DUserPriority:1,
-			IEEE802_1QVLANID:1,
-			Reserved:5;
-		} fields;
-	} */
 	BOOLEAN		enabled;
 	u32		SFID;
 	u8		qos_buf_count;
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 814d2e4..3ccb083 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -862,10 +862,6 @@ static void prepare_rx_complete(void *arg, void *data, int len)
 			netdev_err(nic->netdev,
 				   "get_prepared_info failed(%d)\n", ret);
 		gdm_wimax_rcv_with_cb(nic, prepare_rx_complete, nic);
-		#if 0
-		/* Re-prepare WiMax device */
-		gdm_wimax_prepare_device(nic->netdev);
-		#endif
 	}
 }
 
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 3013bdb..55212f5 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -23,10 +23,6 @@
 
 #define DRIVER_VERSION		"3.2.3"
 
-/*#define ETH_P_IP	0x0800 */
-/*#define ETH_P_ARP	0x0806 */
-/*#define ETH_P_IPV6	0x86DD */
-
 #define H2L(x)		__cpu_to_le16(x)
 #define L2H(x)		__le16_to_cpu(x)
 #define DH2L(x)		__cpu_to_le32(x)
@@ -62,8 +58,6 @@ struct nic {
 
 };
 
-/*#define LOOPBACK_TEST */
-
 int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
 int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
 void unregister_wimax_device(struct phy_dev *phy_dev);
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 0d45eb6..8518a5a 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -169,14 +169,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 	memcpy(&hdr, firm->data, sizeof(hdr));
 
 	array_le32_to_cpu((u32 *)&hdr, 19);
-#if 0
-	if (hdr.magic_code != 0x10767fff) {
-		dev_err(&usbdev->dev, "Invalid magic code 0x%08x\n",
-			hdr.magic_code);
-		ret = -EINVAL;
-		goto out;
-	}
-#endif
+
 	if (hdr.count > MAX_IMG_CNT) {
 		dev_err(&usbdev->dev, "Too many images. %d\n", hdr.count);
 		ret = -EINVAL;
@@ -201,14 +194,6 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 		memcpy(&fw_info, firm->data + pos, sizeof(fw_info));
 
 		array_le32_to_cpu((u32 *)&fw_info, 8);
-#if 0
-		if ((fw_info.id & 0xfffff000) != 0x10767000) {
-			dev_err(&usbdev->dev, "Invalid FW id. 0x%08x\n",
-				fw_info.id);
-			ret = -EIO;
-			goto out;
-		}
-#endif
 
 		if ((fw_info.id & 0xffff) != pid)
 			continue;
-- 
1.8.4

