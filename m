Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3CETdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:33:35 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63640 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3CETdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:33:33 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: [PATCH] tty: ipwireless: Remove redundant NULL check before kfree
Date: Wed,  6 Mar 2013 01:03:22 +0530
Message-Id: <1362512002-3763-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/tty/ipwireless/hardware.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index 97a511f..2c14842 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -1732,8 +1732,7 @@ void ipwireless_hardware_free(struct ipw_hardware *hw)
 	flush_work(&hw->work_rx);
 
 	for (i = 0; i < NL_NUM_OF_ADDRESSES; i++)
-		if (hw->packet_assembler[i] != NULL)
-			kfree(hw->packet_assembler[i]);
+		kfree(hw->packet_assembler[i]);
 
 	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
 		list_for_each_entry_safe(tp, tq, &hw->tx_queue[i], queue) {
-- 
1.7.9.5

