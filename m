Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3DBWzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:55:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758532Ab3DBWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/56] sky2: Threshold for Pause Packet is set wrong
Date: Tue,  2 Apr 2013 15:50:09 -0700
Message-Id: <20130402224716.745931118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mirko Lindner <mlindner@marvell.com>

[ Upstream commit 74f9f42c1c1650e74fb464f76644c9041f996851 ]

The sky2 driver sets the Rx Upper Threshold for Pause Packet generation to a
wrong value which leads to only 2kB of RAM remaining space. This can lead to
Rx overflow errors even with activated flow-control.

Fix: We should increase the value to 8192/8

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sky2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -992,7 +992,7 @@ static void sky2_ramset(struct sky2_hw *
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTHP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTHP), space/2);
 
-		tp = space - 2048/8;
+		tp = space - 8192/8;
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTPP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTPP), space/4);
 	} else {


