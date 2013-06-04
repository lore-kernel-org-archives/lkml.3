Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3FDXT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:19:29 -0400
Received: from 1wt.eu ([62.212.114.60]:35320 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3FDWlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:50 -0400
Message-Id: <20130604172132.959690964@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ram Gupta <ram.gupta5@gmail.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 064/184] serial: 8250, increase PASS_LIMIT
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

With virtual machines like qemu, it's pretty common to see "too much
work for irq4" messages nowadays. This happens when a bunch of output
is printed on the emulated serial console. This is caused by too low
PASS_LIMIT. When ISR loops more than the limit, it spits the message.

I've been using a kernel with doubled the limit and I couldn't see no
problems. Maybe it's time to get rid of the message now?

[2.6.32: background info from Ram Gupta]

> I need a patch for serial driver that increases PASS_LIMIT merged in
> 3.1. I am using 2.6.32 kernel which experiences kernel panic
> occasionally. It will be great if you can backport to 2.6.32 and 3.0
> kernel. The commit ID is e7328ae1  serial: 8250, increase PASS_LIMIT

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit e7328ae1848966181a7ac47e8ae6cddbd2cf55f3)
Cc: Ram Gupta <ram.gupta5@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/serial/8250.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 6a451e8..12e1e9e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -81,7 +81,7 @@ static unsigned int skip_txen_test; /* force skip of txen test at init time */
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	256
+#define PASS_LIMIT	512
 
 #define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
 
-- 
1.7.12.2.21.g234cd45.dirty



