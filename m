Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaEZKZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:25:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52034 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaEZKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:25:00 -0400
Date: Mon, 26 May 2014 19:24:17 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: dgap: remove unneeded kfree() in
 dgap_tty_register_ports()
Message-ID: <20140526102417.GA13799@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it failed to allocate for printer_ports, serial_ports
can be freed in dgap_tty_uninit().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index db24f70..2f47bb7 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4158,10 +4158,9 @@ static int dgap_tty_register_ports(struct board_t *brd)
 
 	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
 					GFP_KERNEL);
-	if (brd->printer_ports == NULL) {
-		kfree(brd->serial_ports);
+	if (brd->printer_ports == NULL)
 		return -ENOMEM;
-	}
+
 	for (i = 0; i < brd->nasync; i++)
 		tty_port_init(&brd->printer_ports[i]);
 
-- 
1.7.1

