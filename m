Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaLUVPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:15:50 -0500
Received: from sauhun.de ([89.238.76.85]:52941 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaLUVPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:47 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 20/28] tty: serial: 8250: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:41 +0100
Message-Id: <1419196495-9626-21-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/tty/serial/8250/8250_omap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 96b69bfd773f..c59e86654834 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1269,7 +1269,6 @@ static struct platform_driver omap8250_platform_driver = {
 		.name		= "omap8250",
 		.pm		= &omap8250_dev_pm_ops,
 		.of_match_table = omap8250_dt_ids,
-		.owner		= THIS_MODULE,
 	},
 	.probe			= omap8250_probe,
 	.remove			= omap8250_remove,
-- 
2.1.3

