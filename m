Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbaEMKkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60776 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760049AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Himangi Saraogi <himangi774@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/182] staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer
Date: Tue, 13 May 2014 11:26:38 +0200
Message-Id: <9a7ae830ba468149107979d2065ffda0ea3591ce.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit abe5d64d1a74195a44cd14624f8178b9f48b7cc7 upstream.

This patch fixes the following sparse warning :
drivers/staging/serqt_usb2/serqt_usb2.c:727:40: warning: restricted __le16 degrades to integer

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 73fc3cc19e33..18d4856c092f 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -725,7 +725,7 @@ static int qt_startup(struct usb_serial *serial)
 		goto startup_error;
 	}
 
-	switch (serial->dev->descriptor.idProduct) {
+	switch (le16_to_cpu(serial->dev->descriptor.idProduct)) {
 	case QUATECH_DSU100:
 	case QUATECH_QSU100:
 	case QUATECH_ESU100A:
-- 
1.9.3

