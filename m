Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaBEUGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:31 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48327 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbaBEUG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 119/213] serial: 8250, increase PASS_LIMIT
Date: Wed, 5 Feb 2014 15:01:14 -0500
Message-ID: <1391630568-49251-120-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e7328ae1848966181a7ac47e8ae6cddbd2cf55f3 upstream.

With virtual machines like qemu, it's pretty common to see "too much
work for irq4" messages nowadays. This happens when a bunch of output
is printed on the emulated serial console. This is caused by too low
PASS_LIMIT. When ISR loops more than the limit, it spits the message.

I've been using a kernel with doubled the limit and I couldn't see no
problems. Maybe it's time to get rid of the message now?

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[PG: drivers/tty/serial/8250.c ---> drivers/serial/8250.c in 2.6.34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/serial/8250.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c1d79a233476..848894773c64 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -82,7 +82,7 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	256
+#define PASS_LIMIT	512
 
 #define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
 
-- 
1.8.5.2

