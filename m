Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaBDMrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:47:09 -0500
Received: from mail.eperm.de ([89.247.134.16]:34118 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaBDMrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:47:08 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: [PATCH 4/5] CPU Jitter RNG: provide status proc files
Date: Tue, 04 Feb 2014 13:41:31 +0100
Message-ID: <2094293.CMEsWJt2a2@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2039634.jSmQAS6tdi@myon.chronox.de>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After successful initialization of the CPU Jitter RNG as part of the
Linux RNG, the two variables defining the memory size of the memory
chunk used for measuring memory access times are set. In case the Jitter
RNG does not successfully initialize, these variables are set to zero.

These two variables can be exported to user space to allow user space to
check whether the CPU Jitter RNG is operational and which memory values
are used. Note, according to tests, the size of the memory chunk has a
direct impact on the execution timing variations.

The exported variables are all read only and can be found at:
/proc/sys/kernel/random. The files are:

jent_memblocksize -- size of one memory block in bytes
jent_memblocks -- number of memory blocks used

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index eb4fe99..4b2267b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1703,6 +1703,20 @@ struct ctl_table random_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
+	{
+		.procname	= "jent_memblocksize",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+		.data		= &input_pool.jent_ec.memblocksize,
+	},
+	{
+		.procname	= "jent_memblocks",
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+		.data		= &input_pool.jent_ec.memblocks,
+	},
 	{ }
 };
 #endif 	/* CONFIG_SYSCTL */
-- 
1.8.5.3


