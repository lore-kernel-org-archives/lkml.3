Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3FKU1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3FKUDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        Lotfi Manseur <lotfi.manseur@gmail.com>
Subject: [ 29/32] USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer
Date: Tue, 11 Jun 2013 13:03:28 -0700
Message-Id: <20130611200129.458595649@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

commit a816e3113b63753c330ca4751ea1d208e93e3015 upstream.

Pointers should not be compared to plain integers.
Quiets the sparse warning:
warning: Using plain integer as NULL pointer

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Cc: Lotfi Manseur <lotfi.manseur@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2173,7 +2173,7 @@ static void ftdi_set_termios(struct tty_
 
 	cflag = termios->c_cflag;
 
-	if (old_termios == 0)
+	if (!old_termios)
 		goto no_skip;
 
 	if (old_termios->c_cflag == termios->c_cflag


