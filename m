Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3LPLBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:01:41 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54705 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3LPLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:01:39 -0500
Date: Mon, 16 Dec 2013 16:31:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Rashika Kheria <rashika.kheria@gmail.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, josh@joshtriplett.org
Subject: [PATCH 2/2] drivers: tty: Mark the function hvc_poll_init() as
 static in hvc_console.c
Message-ID: <0dc41f5b30bf9b5c94e658387ffaf092736c26b2.1387191158.git.rashika.kheria@gmail.com>
References: <0d40902c95942d272a70b1d85b4e311d0cc7afa4.1387191158.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d40902c95942d272a70b1d85b4e311d0cc7afa4.1387191158.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the function hvc_poll_init() as static in hvc/hvc_console.c because
it is not used outside this file.

This eliminates the following warning in hvc/hvc_console.c:
drivers/tty/hvc/hvc_console.c:791:5: warning: no previous prototype for ‘hvc_poll_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/tty/hvc/hvc_console.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 9eba119..50b4688 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -788,7 +788,7 @@ static int hvc_tiocmset(struct tty_struct *tty,
 }
 
 #ifdef CONFIG_CONSOLE_POLL
-int hvc_poll_init(struct tty_driver *driver, int line, char *options)
+static int hvc_poll_init(struct tty_driver *driver, int line, char *options)
 {
 	return 0;
 }
-- 
1.7.9.5

