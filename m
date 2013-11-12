Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3KLSnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:43:20 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:58034 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3KLSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:43:16 -0500
From: Alexandre Demers <alexandre.f.demers@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Silence r8712u info and add verbose option v2
Date: Tue, 12 Nov 2013 13:43:13 -0500
Message-Id: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r8712u pollutes dmesg and logs. Silence it and add a verbose option to KConfig if we ever 
really want to hear about it.

v2: keep netdev_info instead of replacing it by a KERN_NOTICE

---
 drivers/staging/rtl8712/Kconfig        | 7 +++++++
 drivers/staging/rtl8712/rtl871x_mlme.c | 7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/Kconfig b/drivers/staging/rtl8712/Kconfig
index 6a43312..7cae8f8 100644
--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -16,4 +16,11 @@ config R8712_TX_AGGR
 	---help---
 	This option provides transmit aggregation for the Realtek RTL8712 USB device.
 
+config R8712U_DEBUG
+	bool "Realtek RTL8712U Wireless verbose debug"
+	depends on R8712U
+	help
+	  Say Y here in order to have the rtl8712u code generate
+	  verbose debugging messages.
+
 
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 6596154..1226009 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1043,9 +1043,12 @@ void r8712_got_addbareq_event_callback(struct _adapter *adapter, u8 *pbuf)
 	struct	sta_priv *pstapriv = &adapter->stapriv;
 	struct	recv_reorder_ctrl *precvreorder_ctrl = NULL;
 
+#ifdef CONFIG_R8712U_DEBUG
	netdev_info(adapter->pnetdev, "%s: mac = %pM, seq = %d, tid = %d\n",
		    __func__, pAddbareq_pram->MacAddress,
	    pAddbareq_pram->StartSeqNum, pAddbareq_pram->tid);
+#endif
+
 	psta = r8712_get_stainfo(pstapriv, pAddbareq_pram->MacAddress);
 	if (psta) {
 		precvreorder_ctrl =
-- 
1.8.4.2

