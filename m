Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3KBNsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:48:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33231 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3KBNs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:48:28 -0400
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
To: davem@davemloft.net, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com, joe@perches.com,
        apw@canonical.com
Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Subject: [PATCH net-next 04/13] driver: staging: remove unnecessary skb NULL check before calling dev_kfree_skb_irq
Date: Sat,  2 Nov 2013 19:17:45 +0530
Message-Id: <1383400074-30555-5-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_kfree_skb_irq is protected from NULL. No need to check for NULL while
calling this function.

Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 869dcd3..1073880 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2616,8 +2616,7 @@ static void slic_xmit_complete(struct adapter *adapter)
 									address;
 /*      hcmd = (struct slic_hostcmd *) rspbuf->hosthandle; */
 		if (hcmd->type == SLIC_CMD_DUMB) {
-			if (hcmd->skb)
-				dev_kfree_skb_irq(hcmd->skb);
+			dev_kfree_skb_irq(hcmd->skb);
 			slic_cmdq_putdone_irq(adapter, hcmd);
 		}
 		rspbuf->status = 0;
-- 
1.8.4.2

