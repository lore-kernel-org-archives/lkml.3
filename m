Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3AQICo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:02:44 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36095 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab3AQICn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:02:43 -0500
From: Haojun Bao <hjbao@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Thu, 17 Jan 2013 00:01:51 -0800
Subject: [PATCH] Do not tweak clock in pxa serial write() function
Thread-Topic: [PATCH] Do not tweak clock in pxa serial write() function
Thread-Index: Ac30iOglvZvromCqQ9Sg7uMP1p99Ow==
Message-ID: <87k3rc44sq.fsf@bj-lt7.marvell.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.2 (gnu/linux)
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The write() function could be used by printk(), which is atomic and
tweaking clock there can cause "BUG: sleeping function called from
invalid context".

Signed-off-by: Bao Haojun <hjbao@marvell.com>
---
 drivers/tty/serial/pxa.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 2764828..fa1d5ae 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -673,7 +673,6 @@ serial_pxa_console_write(struct console *co, const char *s, unsigned int count)
 	unsigned long flags;
 	int locked = 1;
 
-	clk_prepare_enable(up->clk);
 
 	local_irq_save(flags);
 	if (up->port.sysrq)
@@ -702,7 +701,6 @@ serial_pxa_console_write(struct console *co, const char *s, unsigned int count)
 		spin_unlock(&up->port.lock);
 	local_irq_restore(flags);
 
-	clk_disable_unprepare(up->clk);
 }
 
 #ifdef CONFIG_CONSOLE_POLL
-- 
1.7.10.4
