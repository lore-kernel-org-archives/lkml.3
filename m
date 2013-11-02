Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3KBNsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:48:41 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48402 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3KBNsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:48:36 -0400
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
Subject: [PATCH net-next 05/13] driver: usb/gadget: remove unnecessary skb NULL check before calling dev_kfree_skb_irq
Date: Sat,  2 Nov 2013 19:17:46 +0530
Message-Id: <1383400074-30555-6-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_kfree_skb_irq is protected from NULL. No need to check for NULL
while calling this function.

Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
---
 drivers/usb/gadget/f_phonet.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/f_phonet.c b/drivers/usb/gadget/f_phonet.c
index eb3aa81..9e220b6 100644
--- a/drivers/usb/gadget/f_phonet.c
+++ b/drivers/usb/gadget/f_phonet.c
@@ -393,10 +393,8 @@ static void __pn_reset(struct usb_function *f)
 
 	usb_ep_disable(fp->out_ep);
 	usb_ep_disable(fp->in_ep);
-	if (fp->rx.skb) {
-		dev_kfree_skb_irq(fp->rx.skb);
-		fp->rx.skb = NULL;
-	}
+	dev_kfree_skb_irq(fp->rx.skb);
+	fp->rx.skb = NULL;
 }
 
 static int pn_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
-- 
1.8.4.2

