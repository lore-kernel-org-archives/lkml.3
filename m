Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3FPWY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:24:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46441 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755755Ab3FPWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ying Xue" <ying.xue@windriver.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.187746332@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [32/83] USB: ftdi_sio: Quiet sparse noise about using plain
 integer was NULL pointer
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

commit a816e3113b63753c330ca4751ea1d208e93e3015 upstream.

Pointers should not be compared to plain integers.
Quiets the sparse warning:
warning: Using plain integer as NULL pointer

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2169,7 +2169,7 @@ static void ftdi_set_termios(struct tty_
 
 	cflag = termios->c_cflag;
 
-	if (old_termios == 0)
+	if (!old_termios)
 		goto no_skip;
 
 	if (old_termios->c_cflag == termios->c_cflag

