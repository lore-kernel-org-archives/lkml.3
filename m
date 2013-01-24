Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945920Ab3AXVT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:19:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:41163 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab3AXVS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:18:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Ram Gupta <ram.gupta5@gmail.com>
Subject: [ 08/15] serial: 8250, increase PASS_LIMIT
Date: Thu, 24 Jan 2013 13:18:32 -0800
Message-Id: <20130124211726.749523382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211723.489089115@linuxfoundation.org>
References: <20130124211723.489089115@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit e7328ae1848966181a7ac47e8ae6cddbd2cf55f3 upstream.

With virtual machines like qemu, it's pretty common to see "too much
work for irq4" messages nowadays. This happens when a bunch of output
is printed on the emulated serial console. This is caused by too low
PASS_LIMIT. When ISR loops more than the limit, it spits the message.

I've been using a kernel with doubled the limit and I couldn't see no
problems. Maybe it's time to get rid of the message now?

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ram Gupta <ram.gupta5@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -81,7 +81,7 @@ static unsigned int skip_txen_test; /* f
 #define DEBUG_INTR(fmt...)	do { } while (0)
 #endif
 
-#define PASS_LIMIT	256
+#define PASS_LIMIT	512
 
 #define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
 


