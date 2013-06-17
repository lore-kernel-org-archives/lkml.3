Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3FQReQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50516 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab3FQRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 30/84] USB: whiteheat: fix broken port configuration
Date: Mon, 17 Jun 2013 10:30:34 -0700
Message-Id: <1371490288-23167-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 9eecf22d2b375b9064a20421c6c307b760b03d46 upstream.

When configuring the port (e.g. set_termios) the port minor number
rather than the port number was used in the request (and they only
coincide for minor number 0).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/whiteheat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index b9fca35..347caad 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -649,7 +649,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
 
-	port_settings.port = port->number + 1;
+	port_settings.port = port->number - port->serial->minor + 1;
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
-- 
1.8.1.2

