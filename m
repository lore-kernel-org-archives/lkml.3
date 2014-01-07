Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaAGJ5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:57:34 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38938 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaAGJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:57:31 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: hans.verkuil@cisco.com, m.chehab@samsung.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Ethan Zhao <ethan.kernel@gmail.com>
Subject: [PATCH] media: gspaca: check pointer against NULL before using it in create_urbs()
Date: Tue,  7 Jan 2014 17:56:02 +0800
Message-Id: <1389088562-463-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function alt_xfer() may return NULL, should check its return value passed into
create_urbs() as parameter.

gspca_init_transfer()
{
... ...
ret = create_urbs(gspca_dev,alt_xfer(&intf->altsetting[alt], xfer));
... ...
}

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/media/usb/gspca/gspca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 048507b..eb45bc0 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -761,6 +761,8 @@ static int create_urbs(struct gspca_dev *gspca_dev,
 	struct urb *urb;
 	int n, nurbs, i, psize, npkt, bsize;
 
+	if (!ep)
+		return -EINVAL;
 	/* calculate the packet size and the number of packets */
 	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
 
-- 
1.8.3.4 (Apple Git-47)

