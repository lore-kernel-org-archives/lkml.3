Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaFAN1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:27:45 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36850 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaFAN1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:27:44 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: r8192U_core.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:28:35 +0200
Message-Id: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192u/r8192U_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1bb6143..b88fb6d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -4695,9 +4695,10 @@ static void rtl8192_rx_nomal(struct sk_buff *skb)
 	u32  PacketShiftBytes = 0;
 	rx_desc_819x_usb_aggr_subframe *RxDescr = NULL;
 	u8  PaddingBytes = 0;
+#ifdef USB_RX_AGGREGATION_SUPPORT
 	//add just for testing
-	u8   testing;
-
+	u8   testing = 0;
+#endif
 #endif
 
 	/* 20 is for ps-poll */
-- 
1.7.10.4

