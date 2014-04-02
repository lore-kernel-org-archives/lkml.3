Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaDBK3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:29:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002AbaDBK3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:29:44 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ttyprintk: Fix wrong tty_unregister_driver() call in the error path
Date: Wed,  2 Apr 2014 12:29:41 +0200
Message-Id: <1396434582-30799-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ttyprintk driver calls tty_unregister_driver() wrongly in the error
path of tty_register_driver().  Also, setting ttyprintk_driver to NULL
is utterly superfluous, so let's get rid of it, too.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/char/ttyprintk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index daea84c41743..2a39c5790364 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -210,10 +210,8 @@ static int __init ttyprintk_init(void)
 	return 0;
 
 error:
-	tty_unregister_driver(ttyprintk_driver);
 	put_tty_driver(ttyprintk_driver);
 	tty_port_destroy(&tpk_port.port);
-	ttyprintk_driver = NULL;
 	return ret;
 }
 device_initcall(ttyprintk_init);
-- 
1.9.1

