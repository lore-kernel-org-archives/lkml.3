Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaHMJXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:23:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65370 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaHMJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:23:37 -0400
Date: Wed, 13 Aug 2014 14:53:31 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] Bluetooth: bluecard_cs.c: Remove typedef bluecard_info_t
Message-ID: <20140813092331.GA3272@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
bluecard_info_t. Also, the name of the struct is changed to drop the _t,
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
 drivers/bluetooth/bluecard_cs.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index dfa5043..35e63aa 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -61,7 +61,7 @@ MODULE_LICENSE("GPL");
 /* ======================== Local structures ======================== */
 
 
-typedef struct bluecard_info_t {
+struct bluecard_info {
 	struct pcmcia_device *p_dev;
 
 	struct hci_dev *hdev;
@@ -78,7 +78,7 @@ typedef struct bluecard_info_t {
 
 	unsigned char ctrl_reg;
 	unsigned long hw_state;		/* Status of the hardware and LED control */
-} bluecard_info_t;
+};
 
 
 static int bluecard_config(struct pcmcia_device *link);
@@ -157,7 +157,7 @@ static void bluecard_detach(struct pcmcia_device *p_dev);
 
 static void bluecard_activity_led_timeout(u_long arg)
 {
-	bluecard_info_t *info = (bluecard_info_t *)arg;
+	struct bluecard_info *info = (struct bluecard_info *)arg;
 	unsigned int iobase = info->p_dev->resource[0]->start;
 
 	if (!test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
@@ -173,7 +173,7 @@ static void bluecard_activity_led_timeout(u_long arg)
 }
 
 
-static void bluecard_enable_activity_led(bluecard_info_t *info)
+static void bluecard_enable_activity_led(struct bluecard_info *info)
 {
 	unsigned int iobase = info->p_dev->resource[0]->start;
 
@@ -215,7 +215,7 @@ static int bluecard_write(unsigned int iobase, unsigned int offset, __u8 *buf, i
 }
 
 
-static void bluecard_write_wakeup(bluecard_info_t *info)
+static void bluecard_write_wakeup(struct bluecard_info *info)
 {
 	if (!info) {
 		BT_ERR("Unknown device");
@@ -368,7 +368,8 @@ static int bluecard_read(unsigned int iobase, unsigned int offset, __u8 *buf, in
 }
 
 
-static void bluecard_receive(bluecard_info_t *info, unsigned int offset)
+static void bluecard_receive(struct bluecard_info *info,
+			     unsigned int offset)
 {
 	unsigned int iobase;
 	unsigned char buf[31];
@@ -497,7 +498,7 @@ static void bluecard_receive(bluecard_info_t *info, unsigned int offset)
 
 static irqreturn_t bluecard_interrupt(int irq, void *dev_inst)
 {
-	bluecard_info_t *info = dev_inst;
+	struct bluecard_info *info = dev_inst;
 	unsigned int iobase;
 	unsigned char reg;
 
@@ -562,7 +563,7 @@ static irqreturn_t bluecard_interrupt(int irq, void *dev_inst)
 
 static int bluecard_hci_set_baud_rate(struct hci_dev *hdev, int baud)
 {
-	bluecard_info_t *info = hci_get_drvdata(hdev);
+	struct bluecard_info *info = hci_get_drvdata(hdev);
 	struct sk_buff *skb;
 
 	/* Ericsson baud rate command */
@@ -611,7 +612,7 @@ static int bluecard_hci_set_baud_rate(struct hci_dev *hdev, int baud)
 
 static int bluecard_hci_flush(struct hci_dev *hdev)
 {
-	bluecard_info_t *info = hci_get_drvdata(hdev);
+	struct bluecard_info *info = hci_get_drvdata(hdev);
 
 	/* Drop TX queue */
 	skb_queue_purge(&(info->txq));
@@ -622,7 +623,7 @@ static int bluecard_hci_flush(struct hci_dev *hdev)
 
 static int bluecard_hci_open(struct hci_dev *hdev)
 {
-	bluecard_info_t *info = hci_get_drvdata(hdev);
+	struct bluecard_info *info = hci_get_drvdata(hdev);
 
 	if (test_bit(CARD_HAS_PCCARD_ID, &(info->hw_state)))
 		bluecard_hci_set_baud_rate(hdev, DEFAULT_BAUD_RATE);
@@ -643,7 +644,7 @@ static int bluecard_hci_open(struct hci_dev *hdev)
 
 static int bluecard_hci_close(struct hci_dev *hdev)
 {
-	bluecard_info_t *info = hci_get_drvdata(hdev);
+	struct bluecard_info *info = hci_get_drvdata(hdev);
 
 	if (!test_and_clear_bit(HCI_RUNNING, &(hdev->flags)))
 		return 0;
@@ -663,7 +664,7 @@ static int bluecard_hci_close(struct hci_dev *hdev)
 
 static int bluecard_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	bluecard_info_t *info = hci_get_drvdata(hdev);
+	struct bluecard_info *info = hci_get_drvdata(hdev);
 
 	switch (bt_cb(skb)->pkt_type) {
 	case HCI_COMMAND_PKT:
@@ -691,7 +692,7 @@ static int bluecard_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int bluecard_open(bluecard_info_t *info)
+static int bluecard_open(struct bluecard_info *info)
 {
 	unsigned int iobase = info->p_dev->resource[0]->start;
 	struct hci_dev *hdev;
@@ -806,7 +807,7 @@ static int bluecard_open(bluecard_info_t *info)
 }
 
 
-static int bluecard_close(bluecard_info_t *info)
+static int bluecard_close(struct bluecard_info *info)
 {
 	unsigned int iobase = info->p_dev->resource[0]->start;
 	struct hci_dev *hdev = info->hdev;
@@ -833,7 +834,7 @@ static int bluecard_close(bluecard_info_t *info)
 
 static int bluecard_probe(struct pcmcia_device *link)
 {
-	bluecard_info_t *info;
+	struct bluecard_info *info;
 
 	/* Create new info device */
 	info = devm_kzalloc(&link->dev, sizeof(*info), GFP_KERNEL);
@@ -857,7 +858,7 @@ static void bluecard_detach(struct pcmcia_device *link)
 
 static int bluecard_config(struct pcmcia_device *link)
 {
-	bluecard_info_t *info = link->priv;
+	struct bluecard_info *info = link->priv;
 	int i, n;
 
 	link->config_index = 0x20;
@@ -897,7 +898,7 @@ failed:
 
 static void bluecard_release(struct pcmcia_device *link)
 {
-	bluecard_info_t *info = link->priv;
+	struct bluecard_info *info = link->priv;
 
 	bluecard_close(info);
 
-- 
1.9.1

