Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3FDWuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:50:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35855 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab3FDWoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:06 -0400
Message-Id: <20130604172134.706628267@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 106/184] USB: serial: Fix memory leak in sierra_release()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

commit f7bc5051667b74c3861f79eed98c60d5c3b883f7 upstream.

I found a memory leak in sierra_release() (well sierra_probe() I guess)
that looses 8 bytes each time the driver releases a device.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/sierra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 1b5c9f8..0cbf847 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -925,6 +925,7 @@ static void sierra_release(struct usb_serial *serial)
 			continue;
 		kfree(portdata);
 	}
+	kfree(serial->private);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.12.2.21.g234cd45.dirty



