Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaBDMry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:47:54 -0500
Received: from mail.eperm.de ([89.247.134.16]:38146 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbaBDMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:47:50 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: [PATCH 2/5] CPU Jitter RNG: Enable compilation
Date: Tue, 04 Feb 2014 13:40 +0100
Message-ID: <3180926.X9oRPa7ARL@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2039634.jSmQAS6tdi@myon.chronox.de>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Amend Makefile to allow the CPU Jitter RNG code to be statically
compiled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 290fe5b..480c8f6 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -2,7 +2,8 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= mem.o random.o jitterentropy-base.o
+CFLAGS_jitterentropy-base.o	= -O0
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
-- 
1.8.5.3


