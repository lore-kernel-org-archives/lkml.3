Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaI2IVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:21:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:49075 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaI2IVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:21:09 -0400
Date: Mon, 29 Sep 2014 10:21:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: kbuild test robot <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kbuild-all@01.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: serial: 8250: use 32bit variable for rpm_tx_active
Message-ID: <20140929082103.GA13142@linutronix.de>
References: <54259528.VllWqQU+5yiNGda3%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54259528.VllWqQU+5yiNGda3%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot wrote me:
|  make.cross ARCH=powerpc
|>> ERROR: ".__xchg_called_with_bad_pointer" [drivers/tty/serial/8250/8250.ko] undefined!

The generic implementation of xchg() on arm and x86 works for variables of
size one bye (char). According to the report powerpc does not support
xchg() for one byte sized variables and looking further it seems also to
be the same case for sparc and tile (or for 10 out of 26 architectures
which provide a custom implementation).
For that reason I increase the size of the variable from one to four
bytes to get it work on powerpc (and the others).

Reported-By: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/serial_8250.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index c267412a3ef4..3df10d5f154b 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -84,7 +84,7 @@ struct uart_8250_port {
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
 	unsigned char		cur_iotype;	/* Running I/O type */
-	unsigned char		rpm_tx_active;
+	unsigned int		rpm_tx_active;
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
-- 
2.1.0

