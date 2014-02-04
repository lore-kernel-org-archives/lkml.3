Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaBDMqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:46:53 -0500
Received: from mail.eperm.de ([89.247.134.16]:34106 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaBDMqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:46:50 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: [PATCH 5/5] CPU Jitter RNG: add read/write sysctls
Date: Tue, 04 Feb 2014 13:42:15 +0100
Message-ID: <3340172.IIm0Wgvcue@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2039634.jSmQAS6tdi@myon.chronox.de>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The two added sysctls are read/writable to allow administrators to
tweak the behavior of the CPU Jitter RNG. Normally, no tweaking is
neccessary. Though, some overly cautious users may set the default
to higher values.

The sysctls are found under /proc/sys/kernel/random with the following
files:

jent_memaccessloops -- number of accesses per timing measurement (the
more memory accesses, the higher the timing variations and thus the
entropy per measurement)

jent_osr -- the oversampling rate when generating a random number that
is injected as noise into the Linux RNG

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4b2267b..e689956 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1717,6 +1717,20 @@ struct ctl_table random_table[] = {
 		.proc_handler	= proc_dointvec,
 		.data		= &input_pool.jent_ec.memblocks,
 	},
+	{
+		.procname	= "jent_memaccessloops",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.data		= &input_pool.jent_ec.memaccessloops,
+	},
+	{
+		.procname	= "jent_osr",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.data		= &input_pool.jent_ec.osr,
+	},
 	{ }
 };
 #endif 	/* CONFIG_SYSCTL */
-- 
1.8.5.3


