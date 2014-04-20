Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaDTDgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:36:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47320 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaDTDgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:36:13 -0400
X-Sasl-enc: yreGrsCNf6ALcP9L0KJshhmj0C+wwnoh2cFOXk4yIEzk 1397964972
Message-ID: <53534090.8010405@fastmail.fm>
Date: Sun, 20 Apr 2014 11:35:44 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] staging: gdm72xx: Minor cleanup
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm>
In-Reply-To: <53534051.2020504@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minor white-space fixes as suggested by checkpatch.pl.

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c   | 2 +-
 drivers/staging/gdm72xx/gdm_wimax.c | 2 ++
 drivers/staging/gdm72xx/usb_boot.c  | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 50d43ad..245109e 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -377,7 +377,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	index = get_csr(qcb, SFID, 1);
 	if (index == -1) {
 		netdev_err(nic->netdev,
-			   "QoS ERROR: csr Update Error / Wrong index (%d) \n",
+			   "QoS ERROR: csr Update Error / Wrong index (%d)\n",
 			   index);
 		return;
 	}
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 05ce2a2..5d05cdb 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -199,6 +199,7 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 	u8 *buf = (u8 *) msg;
 	u16 hci_cmd =  (buf[0]<<8) | buf[1];
 	u16 hci_len = (buf[2]<<8) | buf[3];
+
 	netdev_dbg(dev, "H=>D: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	gdm_wimax_send(nic, msg, len);
@@ -310,6 +311,7 @@ static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
 
 	u16 hci_cmd =  ((u8)buf[0]<<8) | (u8)buf[1];
 	u16 hci_len = ((u8)buf[2]<<8) | (u8)buf[3];
+
 	netdev_dbg(dev, "D=>H: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	spin_lock_irqsave(&wm_event.evt_lock, flags);
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 0d45eb6..4d7c61c 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -67,6 +67,7 @@ struct fw_info {
 static void array_le32_to_cpu(u32 *arr, int num)
 {
 	int i;
+
 	for (i = 0; i < num; i++, arr++)
 		*arr = __le32_to_cpu(*arr);
 }
-- 
1.7.12.1

