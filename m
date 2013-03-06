Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3CFURd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:17:33 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35911 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3CFURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:17:32 -0500
From: syamsidhardh@gmail.com
To: linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, jslaby@suse.cz, gregkh@linuxfoundation.org,
        Syam Sidhardhan <s.syam@samsung.com>
Subject: [PATCH v1] tty: ipwireless: Remove redundant NULL check before kfree
Date: Thu,  7 Mar 2013 01:47:24 +0530
Message-Id: <1362601044-6228-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Syam Sidhardhan <s.syam@samsung.com>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
v1 -> Corrected the from address.

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

