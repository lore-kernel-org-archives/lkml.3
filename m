Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaDXIwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaDXIwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/182] staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer
Date: Thu, 24 Apr 2014 09:49:21 +0100
Message-Id: <1398329507-5911-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himangi Saraogi <himangi774@gmail.com>

commit abe5d64d1a74195a44cd14624f8178b9f48b7cc7 upstream.

This patch fixes the following sparse warning :
drivers/staging/serqt_usb2/serqt_usb2.c:727:40: warning: restricted __le16 degrades to integer

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 73fc3cc..18d4856 100644
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
1.9.1

