Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaHMJVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:21:47 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47409 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaHMJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:21:45 -0400
Date: Wed, 13 Aug 2014 14:51:39 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] bluetooth/btuart_cs: Remove typedef btuart_info_t
Message-ID: <20140813092139.GA3189@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for
btuart_info_t. Also, the name of the struct is changed to drop the _t,
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
 drivers/bluetooth/btuart_cs.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index fb948f0..abb4d21 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
 /* ======================== Local structures ======================== */
 
 
-typedef struct btuart_info_t {
+struct btuart_info {
 	struct pcmcia_device *p_dev;
 
 	struct hci_dev *hdev;
@@ -75,7 +75,7 @@ typedef struct btuart_info_t {
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-} btuart_info_t;
+};
 
 
 static int btuart_config(struct pcmcia_device *link);
@@ -127,7 +127,7 @@ static int btuart_write(unsigned int iobase, int fifo_size, __u8 *buf, int len)
 }
 
 
-static void btuart_write_wakeup(btuart_info_t *info)
+static void btuart_write_wakeup(struct btuart_info *info)
 {
 	if (!info) {
 		BT_ERR("Unknown device");
@@ -172,7 +172,7 @@ static void btuart_write_wakeup(btuart_info_t *info)
 }
 
 
-static void btuart_receive(btuart_info_t *info)
+static void btuart_receive(struct btuart_info *info)
 {
 	unsigned int iobase;
 	int boguscount = 0;
@@ -286,7 +286,7 @@ static void btuart_receive(btuart_info_t *info)
 
 static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 {
-	btuart_info_t *info = dev_inst;
+	struct btuart_info *info = dev_inst;
 	unsigned int iobase;
 	int boguscount = 0;
 	int iir, lsr;
@@ -340,7 +340,8 @@ static irqreturn_t btuart_interrupt(int irq, void *dev_inst)
 }
 
 
-static void btuart_change_speed(btuart_info_t *info, unsigned int speed)
+static void btuart_change_speed(struct btuart_info *info,
+				unsigned int speed)
 {
 	unsigned long flags;
 	unsigned int iobase;
@@ -397,7 +398,7 @@ static void btuart_change_speed(btuart_info_t *info, unsigned int speed)
 
 static int btuart_hci_flush(struct hci_dev *hdev)
 {
-	btuart_info_t *info = hci_get_drvdata(hdev);
+	struct btuart_info *info = hci_get_drvdata(hdev);
 
 	/* Drop TX queue */
 	skb_queue_purge(&(info->txq));
@@ -427,7 +428,7 @@ static int btuart_hci_close(struct hci_dev *hdev)
 
 static int btuart_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	btuart_info_t *info = hci_get_drvdata(hdev);
+	struct btuart_info *info = hci_get_drvdata(hdev);
 
 	switch (bt_cb(skb)->pkt_type) {
 	case HCI_COMMAND_PKT:
@@ -455,7 +456,7 @@ static int btuart_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int btuart_open(btuart_info_t *info)
+static int btuart_open(struct btuart_info *info)
 {
 	unsigned long flags;
 	unsigned int iobase = info->p_dev->resource[0]->start;
@@ -521,7 +522,7 @@ static int btuart_open(btuart_info_t *info)
 }
 
 
-static int btuart_close(btuart_info_t *info)
+static int btuart_close(struct btuart_info *info)
 {
 	unsigned long flags;
 	unsigned int iobase = info->p_dev->resource[0]->start;
@@ -550,7 +551,7 @@ static int btuart_close(btuart_info_t *info)
 
 static int btuart_probe(struct pcmcia_device *link)
 {
-	btuart_info_t *info;
+	struct btuart_info *info;
 
 	/* Create new info device */
 	info = devm_kzalloc(&link->dev, sizeof(*info), GFP_KERNEL);
@@ -613,7 +614,7 @@ static int btuart_check_config_notpicky(struct pcmcia_device *p_dev,
 
 static int btuart_config(struct pcmcia_device *link)
 {
-	btuart_info_t *info = link->priv;
+	struct btuart_info *info = link->priv;
 	int i;
 	int try;
 
@@ -654,7 +655,7 @@ failed:
 
 static void btuart_release(struct pcmcia_device *link)
 {
-	btuart_info_t *info = link->priv;
+	struct btuart_info *info = link->priv;
 
 	btuart_close(info);
 
-- 
1.9.1

