Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaDRQKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:10:15 -0400
Received: from smtpout2.laposte.net ([193.253.67.227]:59254 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaDRQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:10:10 -0400
Date: Fri, 18 Apr 2014 18:10:08 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] staging: panel: fix sparse warnings in keypad_read
Message-ID: <20140418161008.GB1258@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two sparse warnings related to keypad_read :
warning: incorrect type in argument 1 (different address spaces)
warning: incorrect type in initializer (incompatible argument 2 (different address spaces))

Signed-off-by: Bastien Armand <armand.bastien@laposte.net>
---
 drivers/staging/panel/panel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 08f9a48..1569e26 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1571,11 +1571,11 @@ static void lcd_init(void)
  */

 static ssize_t keypad_read(struct file *file,
-			   char *buf, size_t count, loff_t *ppos)
+			   char __user *buf, size_t count, loff_t *ppos)
 {

 	unsigned i = *ppos;
-	char *tmp = buf;
+	char __user *tmp = buf;

 	if (keypad_buflen == 0) {
 		if (file->f_flags & O_NONBLOCK)
--
1.7.10.4

