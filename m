Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab3EFVMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:12:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab3EFUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 025/115] USB: io_ti: fix TIOCGSERIAL
Date: Mon,  6 May 2013 13:44:21 -0700
Message-Id: <20130506203058.160038584@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit b6fd35ee5766143d6bc3c333edf374c336ebdca6 upstream.

Fix regression introduced by commit f40d78155 ("USB: io_ti: kill custom
closing_wait implementation") which made TIOCGSERIAL return the wrong
value for closing_wait.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2392,7 +2392,7 @@ static int get_serial_info(struct edgepo
 
 	cwait = edge_port->port->port.closing_wait;
 	if (cwait != ASYNC_CLOSING_WAIT_NONE)
-		cwait = jiffies_to_msecs(closing_wait) / 10;
+		cwait = jiffies_to_msecs(cwait) / 10;
 
 	memset(&tmp, 0, sizeof(tmp));
 


