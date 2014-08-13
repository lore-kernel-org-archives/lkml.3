Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaHMJUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:20:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43938 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaHMJUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:20:02 -0400
Date: Wed, 13 Aug 2014 14:49:56 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] drivers/bluetooth: Remove typedef bt3c_info_t
Message-ID: <20140813091956.GA3117@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
bt3c_info_t. Also, the name of the struct is changed to drop the _t,
to make the name look less typedef-like.

The following Coccinelle semantic patch detects the case:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/bluetooth/bt3c_cs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 1d82721..4f7e8d4 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -67,7 +67,7 @@ MODULE_FIRMWARE("BT3CPCC.bin");
 /* ======================== Local structures ======================== */
 
 
-typedef struct bt3c_info_t {
+struct bt3c_info {
 	struct pcmcia_device *p_dev;
 
 	struct hci_dev *hdev;
@@ -80,7 +80,7 @@ typedef struct bt3c_info_t {
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-} bt3c_info_t;
+};
 
 
 static int bt3c_config(struct pcmcia_device *link);
@@ -175,7 +175,7 @@ static int bt3c_write(unsigned int iobase, int fifo_size, __u8 *buf, int len)
 }
 
 
-static void bt3c_write_wakeup(bt3c_info_t *info)
+static void bt3c_write_wakeup(struct bt3c_info *info)
 {
 	if (!info) {
 		BT_ERR("Unknown device");
@@ -214,7 +214,7 @@ static void bt3c_write_wakeup(bt3c_info_t *info)
 }
 
 
-static void bt3c_receive(bt3c_info_t *info)
+static void bt3c_receive(struct bt3c_info *info)
 {
 	unsigned int iobase;
 	int size = 0, avail;
@@ -336,7 +336,7 @@ static void bt3c_receive(bt3c_info_t *info)
 
 static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 {
-	bt3c_info_t *info = dev_inst;
+	struct bt3c_info *info = dev_inst;
 	unsigned int iobase;
 	int iir;
 	irqreturn_t r = IRQ_NONE;
@@ -388,7 +388,7 @@ static irqreturn_t bt3c_interrupt(int irq, void *dev_inst)
 
 static int bt3c_hci_flush(struct hci_dev *hdev)
 {
-	bt3c_info_t *info = hci_get_drvdata(hdev);
+	struct bt3c_info *info = hci_get_drvdata(hdev);
 
 	/* Drop TX queue */
 	skb_queue_purge(&(info->txq));
@@ -418,7 +418,7 @@ static int bt3c_hci_close(struct hci_dev *hdev)
 
 static int bt3c_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	bt3c_info_t *info = hci_get_drvdata(hdev);
+	struct bt3c_info *info = hci_get_drvdata(hdev);
 	unsigned long flags;
 
 	switch (bt_cb(skb)->pkt_type) {
@@ -451,7 +451,8 @@ static int bt3c_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int bt3c_load_firmware(bt3c_info_t *info, const unsigned char *firmware,
+static int bt3c_load_firmware(struct bt3c_info *info,
+			      const unsigned char *firmware,
 			      int count)
 {
 	char *ptr = (char *) firmware;
@@ -536,7 +537,7 @@ error:
 }
 
 
-static int bt3c_open(bt3c_info_t *info)
+static int bt3c_open(struct bt3c_info *info)
 {
 	const struct firmware *firmware;
 	struct hci_dev *hdev;
@@ -603,7 +604,7 @@ error:
 }
 
 
-static int bt3c_close(bt3c_info_t *info)
+static int bt3c_close(struct bt3c_info *info)
 {
 	struct hci_dev *hdev = info->hdev;
 
@@ -620,7 +621,7 @@ static int bt3c_close(bt3c_info_t *info)
 
 static int bt3c_probe(struct pcmcia_device *link)
 {
-	bt3c_info_t *info;
+	struct bt3c_info *info;
 
 	/* Create new info device */
 	info = devm_kzalloc(&link->dev, sizeof(*info), GFP_KERNEL);
@@ -683,7 +684,7 @@ static int bt3c_check_config_notpicky(struct pcmcia_device *p_dev,
 
 static int bt3c_config(struct pcmcia_device *link)
 {
-	bt3c_info_t *info = link->priv;
+	struct bt3c_info *info = link->priv;
 	int i;
 	unsigned long try;
 
@@ -724,7 +725,7 @@ failed:
 
 static void bt3c_release(struct pcmcia_device *link)
 {
-	bt3c_info_t *info = link->priv;
+	struct bt3c_info *info = link->priv;
 
 	bt3c_close(info);
 
-- 
1.9.1

