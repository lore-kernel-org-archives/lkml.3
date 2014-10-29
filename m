Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaJ2Inm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:43:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21041 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaJ2Inl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:43:41 -0400
Date: Wed, 29 Oct 2014 11:43:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] goldfish: off by one in goldfish_tty_console_setup()
Message-ID: <20141029084325.GB8939@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goldfish_ttys[] array has "goldfish_tty_line_count" number of
elements.  It's allocated in goldfish_tty_create_driver().  This test
should be >= instead of >.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 09495f5..2f68540 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -155,7 +155,7 @@ static struct tty_driver *goldfish_tty_console_device(struct console *c,
 
 static int goldfish_tty_console_setup(struct console *co, char *options)
 {
-	if ((unsigned)co->index > goldfish_tty_line_count)
+	if ((unsigned)co->index >= goldfish_tty_line_count)
 		return -ENODEV;
 	if (goldfish_ttys[co->index].base == 0)
 		return -ENODEV;
