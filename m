Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3KOMHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:07:20 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:44897 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3KOMHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:07:16 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yu-Chen Cho <acho@suse.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, devel@driverdev.osuosl.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback
Date: Fri, 15 Nov 2013 13:07:11 +0100
Message-Id: <1384517231-1605-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/btmtk_usb/btmtk_usb.c: In function ‘btmtk_usb_probe’:
drivers/staging/btmtk_usb/btmtk_usb.c:1610: warning: assignment from incompatible pointer type

Add the new hdev parameter, cfr. commit
7bd8f09f69f8a190f9b8334a07bb0a9237612314 ("Bluetooth: Add hdev parameter to
hdev->send driver callback").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/btmtk_usb/btmtk_usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
index 7a9bf3b57810..9a5ebd6cc512 100644
--- a/drivers/staging/btmtk_usb/btmtk_usb.c
+++ b/drivers/staging/btmtk_usb/btmtk_usb.c
@@ -1284,9 +1284,8 @@ done:
 	kfree_skb(skb);
 }
 
-static int btmtk_usb_send_frame(struct sk_buff *skb)
+static int btmtk_usb_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
 	struct btmtk_usb_data *data = hci_get_drvdata(hdev);
 	struct usb_ctrlrequest *dr;
 	struct urb *urb;
-- 
1.7.9.5

