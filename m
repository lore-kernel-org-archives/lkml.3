Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaDWRmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:42:16 -0400
Received: from smtpout4.laposte.net ([193.253.67.229]:54309 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaDWRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:42:13 -0400
Date: Wed, 23 Apr 2014 19:42:11 +0200
From: Bastien Armand <armand.bastien@laposte.net>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: panel: fix regression in lcd_write
Message-ID: <20140423174210.GA11197@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fix a regression in lcd_write caused by commit
70a8c3eb8546cefe40fb0bc7991e8899b7b91075

Signed-off-by: Bastien Armand <armand.bastien@laposte.net>
---
 drivers/staging/panel/panel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 136671a..acd4b8e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1324,7 +1324,7 @@ static ssize_t lcd_write(struct file *file,
 			   that need some CPU */
 			schedule();

-		if (get_user(c, buf))
+		if (get_user(c, tmp))
 			return -EFAULT;

 		lcd_write_char(c);
--
1.8.5.5

