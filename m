Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaEZKZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:25:32 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39154 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaEZKZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:25:31 -0400
Date: Mon, 26 May 2014 19:24:47 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: dgap: move tty_port_init() for serial_ports.
Message-ID: <20140526102447.GA13805@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If printer_ports which is allocated after serial_ports is failed
to allocate, tty_port_init for serial_ports doesn't need anymore.
So move this after allocating memory for printer_ports.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 2f47bb7..c8f9e66 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -4153,16 +4153,16 @@ static int dgap_tty_register_ports(struct board_t *brd)
 					GFP_KERNEL);
 	if (brd->serial_ports == NULL)
 		return -ENOMEM;
-	for (i = 0; i < brd->nasync; i++)
-		tty_port_init(&brd->serial_ports[i]);
 
 	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
 					GFP_KERNEL);
 	if (brd->printer_ports == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < brd->nasync; i++)
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_init(&brd->serial_ports[i]);
 		tty_port_init(&brd->printer_ports[i]);
+	}
 
 	ch = brd->channels[0];
 	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i]) {
-- 
1.7.1

