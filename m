Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaEDQqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:46:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaEDPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Himangi Saraogi <himangi774@gmail.com>
Subject: [PATCH 3.14 052/158] staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer
Date: Sun,  4 May 2014 11:39:21 -0400
Message-Id: <20140504154037.027703205@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himangi Saraogi <himangi774@gmail.com>

commit abe5d64d1a74195a44cd14624f8178b9f48b7cc7 upstream.

This patch fixes the following sparse warning :
drivers/staging/serqt_usb2/serqt_usb2.c:727:40: warning: restricted __le16 degrades to integer

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/serqt_usb2/serqt_usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -724,7 +724,7 @@ static int qt_startup(struct usb_serial
 		goto startup_error;
 	}
 
-	switch (serial->dev->descriptor.idProduct) {
+	switch (le16_to_cpu(serial->dev->descriptor.idProduct)) {
 	case QUATECH_DSU100:
 	case QUATECH_QSU100:
 	case QUATECH_ESU100A:


