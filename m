Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaHTWST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:18:19 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:34590 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaHTWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:18:12 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/8] staging: et131x: Don't handle rx/tx packets when changing mtu
Date: Wed, 20 Aug 2014 23:17:52 +0100
Message-Id: <1408573078-9320-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to handle any rx/tx interrupts in the middle of an mtu
change, so don't.

After this change, receive and transmit interrupts are only handled in
one place, which paves the way to using NAPI.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index ac6700b..fffe763 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4434,8 +4434,6 @@ static int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EINVAL;
 
 	et131x_disable_txrx(netdev);
-	et131x_handle_send_interrupt(adapter);
-	et131x_handle_recv_interrupt(adapter);
 
 	/* Set the new MTU */
 	netdev->mtu = new_mtu;
-- 
2.1.0

