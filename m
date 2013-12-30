Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3L3WsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 17:48:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3L3WsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 17:48:02 -0500
Date: Mon, 30 Dec 2013 23:48:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230224800.GA8569@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +#define NBT_DBG(fmt, arg...) \
> > +		pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_FW(fmt, arg...) \
> > +		pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_POWER(fmt, arg...) \
> > +		pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_TRANSFER(fmt, arg...) \
> > +		pr_debug("%s: " fmt "" , __func__ , ## arg)
> > +
> > +#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
> > +		pr_debug(fmt "" , ## arg)
> > +
> > +#define NBT_DBG_DMA(fmt, arg...) \
> > +		pr_debug("%s: " fmt "" , __func__ , ## arg)
> 
> 
> I rather not introduce another ton of new debug helpers. Either use the BT_ ones or just spell this out if you need something that is not common.
> 

It looks like idea here is that separate macros may be defined out
separately.

That debugging level should not be neccessary these days, so:

Regards,
							Pavel

commit 1978475804807d6e17015c8aa53ad5606a82a71c
Author: Pavel <pavel@ucw.cz>
Date:   Mon Dec 30 23:47:00 2013 +0100

    Remove custom debugging helpers.
    
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/hci_h4p.h b/drivers/bluetooth/hci_h4p.h
index d1d313b..a2174ea 100644
--- a/drivers/bluetooth/hci_h4p.h
+++ b/drivers/bluetooth/hci_h4p.h
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2005-2008 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
@@ -48,24 +46,6 @@
 #define UART_OMAP_SYSC_NO_IDLE		(1 << UART_OMAP_SYSC_IDLEMODE)
 #define UART_OMAP_SYSC_SMART_IDLE	(2 << UART_OMAP_SYSC_IDLEMODE)
 
-#define NBT_DBG(fmt, arg...) \
-		pr_debug("%s: " fmt "" , __func__ , ## arg)
-
-#define NBT_DBG_FW(fmt, arg...) \
-		pr_debug("%s: " fmt "" , __func__ , ## arg)
-
-#define NBT_DBG_POWER(fmt, arg...) \
-		pr_debug("%s: " fmt "" , __func__ , ## arg)
-
-#define NBT_DBG_TRANSFER(fmt, arg...) \
-		pr_debug("%s: " fmt "" , __func__ , ## arg)
-
-#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
-		pr_debug(fmt "" , ## arg)
-
-#define NBT_DBG_DMA(fmt, arg...) \
-		pr_debug("%s: " fmt "" , __func__ , ## arg)
-
 #define H4P_TRANSFER_MODE		1
 #define H4P_SCHED_TRANSFER_MODE		2
 #define H4P_ACTIVE_MODE			3
diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index 6dbd3b7..85dd106 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -54,7 +54,7 @@ static void hci_h4p_set_clk(struct hci_h4p_info *info, int *clock, int enable)
 
 	spin_lock_irqsave(&info->clocks_lock, flags);
 	if (enable && !*clock) {
-		NBT_DBG_POWER("Enabling %p\n", clock);
+		BT_DBG("Enabling %p\n", clock);
 		clk_prepare_enable(info->uart_fclk);
 		clk_prepare_enable(info->uart_iclk);
 		if (atomic_read(&info->clk_users) == 0)
@@ -63,7 +63,7 @@ static void hci_h4p_set_clk(struct hci_h4p_info *info, int *clock, int enable)
 	}
 
 	if (!enable && *clock) {
-		NBT_DBG_POWER("Disabling %p\n", clock);
+		BT_DBG("Disabling %p\n", clock);
 		if (atomic_dec_and_test(&info->clk_users))
 			hci_h4p_store_regs(info);
 		clk_disable_unprepare(info->uart_fclk);
@@ -114,7 +114,7 @@ static inline void h4p_schedule_pm(struct hci_h4p_info *info)
 
 static void hci_h4p_disable_tx(struct hci_h4p_info *info)
 {
-	NBT_DBG_POWER("\n");
+	BT_DBG("\n");
 
 	if (!info->pm_enabled)
 		return;
@@ -130,7 +130,7 @@ static void hci_h4p_disable_tx(struct hci_h4p_info *info)
 void hci_h4p_enable_tx(struct hci_h4p_info *info)
 {
 	unsigned long flags;
-	NBT_DBG_POWER("\n");
+	BT_DBG("\n");
 
 	if (!info->pm_enabled)
 		return;
@@ -197,7 +197,7 @@ int hci_h4p_send_alive_packet(struct hci_h4p_info *info)
 	unsigned long flags;
 	int len;
 
-	NBT_DBG("Sending alive packet\n");
+	BT_DBG("Sending alive packet\n");
 
 	len = H4_TYPE_SIZE + sizeof(*hdr) + sizeof(*pkt);
 	skb = bt_skb_alloc(len, GFP_KERNEL);
@@ -217,7 +217,7 @@ int hci_h4p_send_alive_packet(struct hci_h4p_info *info)
 		     UART_IER_THRI);
 	spin_unlock_irqrestore(&info->lock, flags);
 
-	NBT_DBG("Alive packet sent\n");
+	BT_DBG("Alive packet sent\n");
 
 	return 0;
 }
@@ -228,7 +228,7 @@ static void hci_h4p_alive_packet(struct hci_h4p_info *info,
 	struct hci_h4p_alive_hdr *hdr;
 	struct hci_h4p_alive_pkt *pkt;
 
-	NBT_DBG("Received alive packet\n");
+	BT_DBG("Received alive packet\n");
 	hdr = (struct hci_h4p_alive_hdr *)skb->data;
 	if (hdr->dlen != sizeof(*pkt)) {
 		dev_err(info->dev, "Corrupted alive message\n");
@@ -256,7 +256,7 @@ static int hci_h4p_send_negotiation(struct hci_h4p_info *info)
 	int err, len;
 	u16 sysclk;
 
-	NBT_DBG("Sending negotiation..\n");
+	BT_DBG("Sending negotiation..\n");
 
 	switch (info->bt_sysclk) {
 	case 1:
@@ -326,7 +326,7 @@ static int hci_h4p_send_negotiation(struct hci_h4p_info *info)
 	if (info->init_error < 0)
 		return info->init_error;
 
-	NBT_DBG("Negotiation succesful\n");
+	BT_DBG("Negotiation succesful\n");
 	return 0;
 }
 
@@ -448,14 +448,14 @@ static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
 		}
 
 		if (!test_bit(HCI_UP, &info->hdev->flags)) {
-			NBT_DBG("fw_event\n");
+			BT_DBG("fw_event\n");
 			hci_h4p_parse_fw_event(info, skb);
 			return;
 		}
 	}
 
 	hci_recv_frame(skb);
-	NBT_DBG("Frame sent to upper layer\n");
+	BT_DBG("Frame sent to upper layer\n");
 }
 
 static inline void hci_h4p_handle_byte(struct hci_h4p_info *info, u8 byte)
@@ -514,8 +514,8 @@ static void hci_h4p_rx_tasklet(unsigned long data)
 	u8 byte;
 	struct hci_h4p_info *info = (struct hci_h4p_info *)data;
 
-	NBT_DBG("tasklet woke up\n");
-	NBT_DBG_TRANSFER("rx_tasklet woke up\ndata ");
+	BT_DBG("tasklet woke up\n");
+	BT_DBG("rx_tasklet woke up\ndata ");
 
 	while (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
 		byte = hci_h4p_inb(info, UART_RX);
@@ -535,7 +535,7 @@ static void hci_h4p_rx_tasklet(unsigned long data)
 			info->rx_skb->dev = (void *)info->hdev;
 		}
 		info->hdev->stat.byte_rx++;
-		NBT_DBG_TRANSFER_NF("0x%.2x  ", byte);
+		pr_debug("0x%.2x  ", byte);
 		hci_h4p_handle_byte(info, byte);
 	}
 
@@ -551,8 +551,8 @@ static void hci_h4p_rx_tasklet(unsigned long data)
 	}
 
 finish_rx:
-	NBT_DBG_TRANSFER_NF("\n");
-	NBT_DBG("rx_ended\n");
+	pr_debug("\n");
+	BT_DBG("rx_ended\n");
 }
 
 static void hci_h4p_tx_tasklet(unsigned long data)
@@ -561,8 +561,8 @@ static void hci_h4p_tx_tasklet(unsigned long data)
 	struct sk_buff *skb;
 	struct hci_h4p_info *info = (struct hci_h4p_info *)data;
 
-	NBT_DBG("tasklet woke up\n");
-	NBT_DBG_TRANSFER("tx_tasklet woke up\n data ");
+	BT_DBG("tasklet woke up\n");
+	BT_DBG("tx_tasklet woke up\n data ");
 
 	if (info->autorts != info->rx_enabled) {
 		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
@@ -587,7 +587,7 @@ static void hci_h4p_tx_tasklet(unsigned long data)
 	skb = skb_dequeue(&info->txq);
 	if (!skb) {
 		/* No data in buffer */
-		NBT_DBG("skb ready\n");
+		BT_DBG("skb ready\n");
 		if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
 			hci_h4p_outb(info, UART_IER,
 				     hci_h4p_inb(info, UART_IER) &
@@ -605,13 +605,13 @@ static void hci_h4p_tx_tasklet(unsigned long data)
 	/* Copy data to tx fifo */
 	while (!(hci_h4p_inb(info, UART_OMAP_SSR) & UART_OMAP_SSR_TXFULL) &&
 	       (sent < skb->len)) {
-		NBT_DBG_TRANSFER_NF("0x%.2x ", skb->data[sent]);
+		pr_debug("0x%.2x ", skb->data[sent]);
 		hci_h4p_outb(info, UART_TX, skb->data[sent]);
 		sent++;
 	}
 
 	info->hdev->stat.byte_tx += sent;
-	NBT_DBG_TRANSFER_NF("\n");
+	pr_debug("\n");
 	if (skb->len == sent) {
 		kfree_skb(skb);
 	} else {
@@ -642,7 +642,7 @@ static irqreturn_t hci_h4p_interrupt(int irq, void *data)
 	if (iir & UART_IIR_NO_INT)
 		return IRQ_HANDLED;
 
-	NBT_DBG("In interrupt handler iir 0x%.2x\n", iir);
+	BT_DBG("In interrupt handler iir 0x%.2x\n", iir);
 
 	iir &= UART_IIR_ID;
 
@@ -688,7 +688,7 @@ static irqreturn_t hci_h4p_wakeup_interrupt(int irq, void *dev_inst)
 		return IRQ_HANDLED;
 	}
 
-	NBT_DBG_POWER("gpio interrupt %d\n", should_wakeup);
+	BT_DBG("gpio interrupt %d\n", should_wakeup);
 
 	/* Check if wee have missed some interrupts */
 	if (info->rx_enabled == should_wakeup)
@@ -970,7 +970,7 @@ again:
 	info->alive_cmd_skb = NULL;
 	set_bit(HCI_RUNNING, &hdev->flags);
 
-	NBT_DBG("hci up and running\n");
+	BT_DBG("hci up and running\n");
 	return 0;
 
 err_clean:
@@ -1030,7 +1030,7 @@ static int hci_h4p_hci_send_frame(struct sk_buff *skb)
 		return -ENODEV;
 	}
 
-	NBT_DBG("dev %p, skb %p\n", hdev, skb);
+	BT_DBG("dev %p, skb %p\n", hdev, skb);
 
 	info = hci_get_drvdata(hdev);
 
@@ -1188,10 +1188,10 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	info->reset_gpio_shared = bt_plat_data->reset_gpio_shared;
 	info->bt_sysclk = bt_plat_data->bt_sysclk;
 
-	NBT_DBG("RESET gpio: %d\n", info->reset_gpio);
-	NBT_DBG("BTWU gpio: %d\n", info->bt_wakeup_gpio);
-	NBT_DBG("HOSTWU gpio: %d\n", info->host_wakeup_gpio);
-	NBT_DBG("sysclk: %d\n", info->bt_sysclk);
+	BT_DBG("RESET gpio: %d\n", info->reset_gpio);
+	BT_DBG("BTWU gpio: %d\n", info->bt_wakeup_gpio);
+	BT_DBG("HOSTWU gpio: %d\n", info->host_wakeup_gpio);
+	BT_DBG("sysclk: %d\n", info->bt_sysclk);
 
 	init_completion(&info->test_completion);
 	complete_all(&info->test_completion);
diff --git a/drivers/bluetooth/nokia_fw-bcm.c b/drivers/bluetooth/nokia_fw-bcm.c
index 9c01a6a..0cf8535 100644
--- a/drivers/bluetooth/nokia_fw-bcm.c
+++ b/drivers/bluetooth/nokia_fw-bcm.c
@@ -73,7 +73,7 @@ void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
 	}
 
 	if (fw_skb->data[1] == 0x01 && fw_skb->data[2] == 0xfc && fw_skb->len >= 10) {
-		NBT_DBG_FW("Setting bluetooth address\n");
+		BT_DBG("Setting bluetooth address\n");
 		err = hci_h4p_bcm_set_bdaddr(info, fw_skb);
 		if (err < 0) {
 			kfree_skb(fw_skb);
@@ -99,7 +99,7 @@ int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
 
 	info->fw_error = 0;
 
-	NBT_DBG_FW("Sending firmware\n");
+	BT_DBG("Sending firmware\n");
 
 	time = jiffies;
 
@@ -108,7 +108,7 @@ int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
 	if (!skb)
 		return -ENODATA;
 
-	NBT_DBG_FW("Sending commands\n");
+	BT_DBG("Sending commands\n");
 
 	/*
 	 * Disable smart-idle as UART TX interrupts
@@ -135,7 +135,7 @@ int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
 		return -EPROTO;
 	}
 
-	NBT_DBG_FW("Firmware sent in %d msecs\n",
+	BT_DBG("Firmware sent in %d msecs\n",
 		   jiffies_to_msecs(jiffies-time));
 
 	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
diff --git a/drivers/bluetooth/nokia_fw-csr.c b/drivers/bluetooth/nokia_fw-csr.c
index 23c5fc5..886b721 100644
--- a/drivers/bluetooth/nokia_fw-csr.c
+++ b/drivers/bluetooth/nokia_fw-csr.c
@@ -53,7 +53,7 @@ int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
 
 	info->fw_error = 0;
 
-	NBT_DBG_FW("Sending firmware\n");
+	BT_DBG("Sending firmware\n");
 	skb = skb_dequeue(fw_queue);
 
 	if (!skb)
@@ -90,7 +90,7 @@ int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
 	}
 
 	for (count = 1; ; count++) {
-		NBT_DBG_FW("Sending firmware command %d\n", count);
+		BT_DBG("Sending firmware command %d\n", count);
 		init_completion(&info->fw_completion);
 		skb_queue_tail(&info->txq, skb);
 		spin_lock_irqsave(&info->lock, flags);
diff --git a/drivers/bluetooth/nokia_fw-ti1273.c b/drivers/bluetooth/nokia_fw-ti1273.c
index 2825504..fd82494 100644
--- a/drivers/bluetooth/nokia_fw-ti1273.c
+++ b/drivers/bluetooth/nokia_fw-ti1273.c
@@ -63,7 +63,7 @@ int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
 
 	info->fw_error = 0;
 
-	NBT_DBG_FW("Sending firmware\n");
+	BT_DBG("Sending firmware\n");
 
 	time = jiffies;
 
@@ -72,7 +72,7 @@ int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
 	if (!skb)
 		return -ENODATA;
 
-	NBT_DBG_FW("Sending commands\n");
+	BT_DBG("Sending commands\n");
 	/* Check if this is bd_address packet */
 	init_completion(&info->fw_completion);
 	hci_h4p_smart_idle(info, 0);
@@ -93,7 +93,7 @@ int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
 		return -EPROTO;
 	}
 
-	NBT_DBG_FW("Firmware sent in %d msecs\n",
+	BT_DBG("Firmware sent in %d msecs\n",
 		   jiffies_to_msecs(jiffies-time));
 
 	hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
diff --git a/drivers/bluetooth/nokia_fw.c b/drivers/bluetooth/nokia_fw.c
index b3d39f9..f69efd8 100644
--- a/drivers/bluetooth/nokia_fw.c
+++ b/drivers/bluetooth/nokia_fw.c
@@ -38,7 +38,7 @@ static int hci_h4p_open_firmware(struct hci_h4p_info *info,
 	int err;
 
 	fw_pos = 0;
-	NBT_DBG_FW("Opening firmware man_id 0x%.2x ver_id 0x%.2x\n",
+	BT_DBG("Opening firmware man_id 0x%.2x ver_id 0x%.2x\n",
 			info->man_id, info->ver_id);
 	switch (info->man_id) {
 	case H4P_ID_TI1271:
diff --git a/drivers/bluetooth/nokia_uart.c b/drivers/bluetooth/nokia_uart.c
index fd94a98..c19b8d2 100644
--- a/drivers/bluetooth/nokia_uart.c
+++ b/drivers/bluetooth/nokia_uart.c
@@ -100,7 +100,7 @@ void hci_h4p_change_speed(struct hci_h4p_info *info, unsigned long speed)
 	unsigned int divisor;
 	u8 lcr, mdr1;
 
-	NBT_DBG("Setting speed %lu\n", speed);
+	BT_DBG("Setting speed %lu\n", speed);
 
 	if (speed >= 460800) {
 		divisor = UART_CLOCK / 13 / speed;


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
