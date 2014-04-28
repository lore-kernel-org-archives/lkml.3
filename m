Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaD1Bbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42939 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Himangi Saraogi" <himangi774@gmail.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.725554248@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 39/94] staging:serqt_usb2: Fix sparse warning
 restricted __le16 degrades to integer
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Himangi Saraogi <himangi774@gmail.com>

commit abe5d64d1a74195a44cd14624f8178b9f48b7cc7 upstream.

This patch fixes the following sparse warning :
drivers/staging/serqt_usb2/serqt_usb2.c:727:40: warning: restricted __le16 degrades to integer

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -772,7 +772,7 @@ static int qt_startup(struct usb_serial
 		goto startup_error;
 	}
 
-	switch (serial->dev->descriptor.idProduct) {
+	switch (le16_to_cpu(serial->dev->descriptor.idProduct)) {
 	case QUATECH_DSU100:
 	case QUATECH_QSU100:
 	case QUATECH_ESU100A:

