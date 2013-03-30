Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3C3Lkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 07:40:43 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61718 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3C3Lkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 07:40:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] cpufreq: Raname index as data in cpufreq_frequency_table
Date: Sat, 30 Mar 2013 17:10:26 +0530
Message-Id: <03ca6f17860d290cfc67e51969062612f0ab26ab.1364643234.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Index" field of struct cpufreq_frequency_table was never index and isn't used
at all by cpufreq core. And is only useful for cpufreq drivers for their
personal use.

Many people now a days blindly set it in ascending order with the assumption
that core is using it for some work.

This patch renames it to "data" as that's what its purpose it. All users of the
same are fixed too.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

This might not apply cleanly as it depends on a lot of work already being done.
And so is pushed here:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-index-to-data

 Documentation/cpu-freq/cpu-drivers.txt             |  10 +-
 arch/arm/mach-davinci/da850.c                      |   8 +-
 arch/arm/mach-s3c24xx/pll-s3c2410.c                |  54 +++++-----
 arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c       |  54 +++++-----
 arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c       | 110 ++++++++++-----------
 arch/arm/mach-shmobile/clock-sh7372.c              |   6 +-
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |   2 +-
 arch/mips/loongson/lemote-2f/clock.c               |   2 +-
 arch/powerpc/platforms/cell/cbe_cpufreq.c          |   4 +-
 drivers/base/power/opp.c                           |   4 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   6 +-
 drivers/cpufreq/blackfin-cpufreq.c                 |  10 +-
 drivers/cpufreq/e_powersaver.c                     |   8 +-
 drivers/cpufreq/freq_table.c                       |  26 ++---
 drivers/cpufreq/ia64-acpi-cpufreq.c                |   2 +-
 drivers/cpufreq/imx-cpufreq.c                      |   4 +-
 drivers/cpufreq/kirkwood-cpufreq.c                 |   2 +-
 drivers/cpufreq/longhaul.c                         |  16 +--
 drivers/cpufreq/loongson2_cpufreq.c                |   2 +-
 drivers/cpufreq/p4-clockmod.c                      |   4 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |   4 +-
 drivers/cpufreq/powernow-k6.c                      |   8 +-
 drivers/cpufreq/powernow-k7.c                      |  16 +--
 drivers/cpufreq/powernow-k8.c                      |  18 ++--
 drivers/cpufreq/pxa2xx-cpufreq.c                   |   8 +-
 drivers/cpufreq/pxa3xx-cpufreq.c                   |   4 +-
 drivers/cpufreq/s3c2416-cpufreq.c                  |   2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |   2 +-
 drivers/cpufreq/sc520_freq.c                       |   2 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c               |  12 +--
 drivers/cpufreq/sparc-us3-cpufreq.c                |   8 +-
 drivers/cpufreq/spear-cpufreq.c                    |   4 +-
 drivers/cpufreq/speedstep-centrino.c               |   8 +-
 drivers/cpufreq/tegra-cpufreq.c                    |   2 +-
 drivers/mfd/db8500-prcmu.c                         |  10 +-
 drivers/sh/clk/core.c                              |   4 +-
 include/linux/cpufreq.h                            |   2 +-
 37 files changed, 221 insertions(+), 227 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index a3585ea..ead563a 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -186,7 +186,7 @@ As most cpufreq processors only allow for being set to a few specific
 frequencies, a "frequency table" with some functions might assist in
 some work of the processor driver. Such a "frequency table" consists
 of an array of struct cpufreq_frequency_table entries, with any value in
-"index" you want to use, and the corresponding frequency in
+"data" you want to use, and the corresponding frequency in
 "frequency". At the end of the table, you need to add a
 cpufreq_frequency_table entry with frequency set to CPUFREQ_TABLE_END. And
 if you want to skip one entry in the table, set the frequency to 
@@ -214,10 +214,4 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 is the corresponding frequency table helper for the ->target
 stage. Just pass the values to this function, and the unsigned int
 index returns the number of the frequency table entry which contains
-the frequency the CPU shall be set to. PLEASE NOTE: This is not the
-"index" which is in this cpufreq_table_entry.index, but instead
-cpufreq_table[index]. So, the new frequency is
-cpufreq_table[index].frequency, and the value you stored into the
-frequency table "index" field is
-cpufreq_table[index].index.
-
+the frequency the CPU shall be set to.
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 0c4a26d..5b17f57 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -958,7 +958,7 @@ static const struct da850_opp da850_opp_96 = {
 
 #define OPP(freq) 		\
 	{				\
-		.index = (unsigned int) &da850_opp_##freq,	\
+		.data = (unsigned int) &da850_opp_##freq,	\
 		.frequency = freq * 1000, \
 	}
 
@@ -970,7 +970,7 @@ static struct cpufreq_frequency_table da850_freq_table[] = {
 	OPP(200),
 	OPP(96),
 	{
-		.index		= 0,
+		.data		= 0,
 		.frequency	= CPUFREQ_TABLE_END,
 	},
 };
@@ -998,7 +998,7 @@ static int da850_set_voltage(unsigned int index)
 	if (!cvdd)
 		return -ENODEV;
 
-	opp = (struct da850_opp *) cpufreq_info.freq_table[index].index;
+	opp = (struct da850_opp *) cpufreq_info.freq_table[index].data;
 
 	return regulator_set_voltage(cvdd, opp->cvdd_min, opp->cvdd_max);
 }
@@ -1079,7 +1079,7 @@ static int da850_set_pll0rate(struct clk *clk, unsigned long index)
 	struct pll_data *pll = clk->pll_data;
 	int ret;
 
-	opp = (struct da850_opp *) cpufreq_info.freq_table[index].index;
+	opp = (struct da850_opp *) cpufreq_info.freq_table[index].data;
 	prediv = opp->prediv;
 	mult = opp->mult;
 	postdiv = opp->postdiv;
diff --git a/arch/arm/mach-s3c24xx/pll-s3c2410.c b/arch/arm/mach-s3c24xx/pll-s3c2410.c
index dcf3420..5051f74 100644
--- a/arch/arm/mach-s3c24xx/pll-s3c2410.c
+++ b/arch/arm/mach-s3c24xx/pll-s3c2410.c
@@ -33,36 +33,36 @@
 #include <plat/cpu-freq-core.h>
 
 static struct cpufreq_frequency_table pll_vals_12MHz[] = {
-    { .frequency = 34000000,  .index = PLLVAL(82, 2, 3),   },
-    { .frequency = 45000000,  .index = PLLVAL(82, 1, 3),   },
-    { .frequency = 51000000,  .index = PLLVAL(161, 3, 3),  },
-    { .frequency = 48000000,  .index = PLLVAL(120, 2, 3),  },
-    { .frequency = 56000000,  .index = PLLVAL(142, 2, 3),  },
-    { .frequency = 68000000,  .index = PLLVAL(82, 2, 2),   },
-    { .frequency = 79000000,  .index = PLLVAL(71, 1, 2),   },
-    { .frequency = 85000000,  .index = PLLVAL(105, 2, 2),  },
-    { .frequency = 90000000,  .index = PLLVAL(112, 2, 2),  },
-    { .frequency = 101000000, .index = PLLVAL(127, 2, 2),  },
-    { .frequency = 113000000, .index = PLLVAL(105, 1, 2),  },
-    { .frequency = 118000000, .index = PLLVAL(150, 2, 2),  },
-    { .frequency = 124000000, .index = PLLVAL(116, 1, 2),  },
-    { .frequency = 135000000, .index = PLLVAL(82, 2, 1),   },
-    { .frequency = 147000000, .index = PLLVAL(90, 2, 1),   },
-    { .frequency = 152000000, .index = PLLVAL(68, 1, 1),   },
-    { .frequency = 158000000, .index = PLLVAL(71, 1, 1),   },
-    { .frequency = 170000000, .index = PLLVAL(77, 1, 1),   },
-    { .frequency = 180000000, .index = PLLVAL(82, 1, 1),   },
-    { .frequency = 186000000, .index = PLLVAL(85, 1, 1),   },
-    { .frequency = 192000000, .index = PLLVAL(88, 1, 1),   },
-    { .frequency = 203000000, .index = PLLVAL(161, 3, 1),  },
+    { .frequency = 34000000,  .data = PLLVAL(82, 2, 3),   },
+    { .frequency = 45000000,  .data = PLLVAL(82, 1, 3),   },
+    { .frequency = 51000000,  .data = PLLVAL(161, 3, 3),  },
+    { .frequency = 48000000,  .data = PLLVAL(120, 2, 3),  },
+    { .frequency = 56000000,  .data = PLLVAL(142, 2, 3),  },
+    { .frequency = 68000000,  .data = PLLVAL(82, 2, 2),   },
+    { .frequency = 79000000,  .data = PLLVAL(71, 1, 2),   },
+    { .frequency = 85000000,  .data = PLLVAL(105, 2, 2),  },
+    { .frequency = 90000000,  .data = PLLVAL(112, 2, 2),  },
+    { .frequency = 101000000, .data = PLLVAL(127, 2, 2),  },
+    { .frequency = 113000000, .data = PLLVAL(105, 1, 2),  },
+    { .frequency = 118000000, .data = PLLVAL(150, 2, 2),  },
+    { .frequency = 124000000, .data = PLLVAL(116, 1, 2),  },
+    { .frequency = 135000000, .data = PLLVAL(82, 2, 1),   },
+    { .frequency = 147000000, .data = PLLVAL(90, 2, 1),   },
+    { .frequency = 152000000, .data = PLLVAL(68, 1, 1),   },
+    { .frequency = 158000000, .data = PLLVAL(71, 1, 1),   },
+    { .frequency = 170000000, .data = PLLVAL(77, 1, 1),   },
+    { .frequency = 180000000, .data = PLLVAL(82, 1, 1),   },
+    { .frequency = 186000000, .data = PLLVAL(85, 1, 1),   },
+    { .frequency = 192000000, .data = PLLVAL(88, 1, 1),   },
+    { .frequency = 203000000, .data = PLLVAL(161, 3, 1),  },
 
     /* 2410A extras */
 
-    { .frequency = 210000000, .index = PLLVAL(132, 2, 1),  },
-    { .frequency = 226000000, .index = PLLVAL(105, 1, 1),  },
-    { .frequency = 266000000, .index = PLLVAL(125, 1, 1),  },
-    { .frequency = 268000000, .index = PLLVAL(126, 1, 1),  },
-    { .frequency = 270000000, .index = PLLVAL(127, 1, 1),  },
+    { .frequency = 210000000, .data = PLLVAL(132, 2, 1),  },
+    { .frequency = 226000000, .data = PLLVAL(105, 1, 1),  },
+    { .frequency = 266000000, .data = PLLVAL(125, 1, 1),  },
+    { .frequency = 268000000, .data = PLLVAL(126, 1, 1),  },
+    { .frequency = 270000000, .data = PLLVAL(127, 1, 1),  },
 };
 
 static int s3c2410_plls_add(struct device *dev, struct subsys_interface *sif)
diff --git a/arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c b/arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c
index 6737817..63f86e7 100644
--- a/arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c
+++ b/arch/arm/mach-s3c24xx/pll-s3c2440-12000000.c
@@ -21,33 +21,33 @@
 #include <plat/cpu-freq-core.h>
 
 static struct cpufreq_frequency_table s3c2440_plls_12[] __initdata = {
-	{ .frequency = 75000000,	.index = PLLVAL(0x75, 3, 3),  }, 	/* FVco 600.000000 */
-	{ .frequency = 80000000,	.index = PLLVAL(0x98, 4, 3),  }, 	/* FVco 640.000000 */
-	{ .frequency = 90000000,	.index = PLLVAL(0x70, 2, 3),  }, 	/* FVco 720.000000 */
-	{ .frequency = 100000000,	.index = PLLVAL(0x5c, 1, 3),  }, 	/* FVco 800.000000 */
-	{ .frequency = 110000000,	.index = PLLVAL(0x66, 1, 3),  }, 	/* FVco 880.000000 */
-	{ .frequency = 120000000,	.index = PLLVAL(0x70, 1, 3),  }, 	/* FVco 960.000000 */
-	{ .frequency = 150000000,	.index = PLLVAL(0x75, 3, 2),  }, 	/* FVco 600.000000 */
-	{ .frequency = 160000000,	.index = PLLVAL(0x98, 4, 2),  }, 	/* FVco 640.000000 */
-	{ .frequency = 170000000,	.index = PLLVAL(0x4d, 1, 2),  }, 	/* FVco 680.000000 */
-	{ .frequency = 180000000,	.index = PLLVAL(0x70, 2, 2),  }, 	/* FVco 720.000000 */
-	{ .frequency = 190000000,	.index = PLLVAL(0x57, 1, 2),  }, 	/* FVco 760.000000 */
-	{ .frequency = 200000000,	.index = PLLVAL(0x5c, 1, 2),  }, 	/* FVco 800.000000 */
-	{ .frequency = 210000000,	.index = PLLVAL(0x84, 2, 2),  }, 	/* FVco 840.000000 */
-	{ .frequency = 220000000,	.index = PLLVAL(0x66, 1, 2),  }, 	/* FVco 880.000000 */
-	{ .frequency = 230000000,	.index = PLLVAL(0x6b, 1, 2),  }, 	/* FVco 920.000000 */
-	{ .frequency = 240000000,	.index = PLLVAL(0x70, 1, 2),  }, 	/* FVco 960.000000 */
-	{ .frequency = 300000000,	.index = PLLVAL(0x75, 3, 1),  }, 	/* FVco 600.000000 */
-	{ .frequency = 310000000,	.index = PLLVAL(0x93, 4, 1),  }, 	/* FVco 620.000000 */
-	{ .frequency = 320000000,	.index = PLLVAL(0x98, 4, 1),  }, 	/* FVco 640.000000 */
-	{ .frequency = 330000000,	.index = PLLVAL(0x66, 2, 1),  }, 	/* FVco 660.000000 */
-	{ .frequency = 340000000,	.index = PLLVAL(0x4d, 1, 1),  }, 	/* FVco 680.000000 */
-	{ .frequency = 350000000,	.index = PLLVAL(0xa7, 4, 1),  }, 	/* FVco 700.000000 */
-	{ .frequency = 360000000,	.index = PLLVAL(0x70, 2, 1),  }, 	/* FVco 720.000000 */
-	{ .frequency = 370000000,	.index = PLLVAL(0xb1, 4, 1),  }, 	/* FVco 740.000000 */
-	{ .frequency = 380000000,	.index = PLLVAL(0x57, 1, 1),  }, 	/* FVco 760.000000 */
-	{ .frequency = 390000000,	.index = PLLVAL(0x7a, 2, 1),  }, 	/* FVco 780.000000 */
-	{ .frequency = 400000000,	.index = PLLVAL(0x5c, 1, 1),  }, 	/* FVco 800.000000 */
+	{ .frequency = 75000000,	.data = PLLVAL(0x75, 3, 3),  }, 	/* FVco 600.000000 */
+	{ .frequency = 80000000,	.data = PLLVAL(0x98, 4, 3),  }, 	/* FVco 640.000000 */
+	{ .frequency = 90000000,	.data = PLLVAL(0x70, 2, 3),  }, 	/* FVco 720.000000 */
+	{ .frequency = 100000000,	.data = PLLVAL(0x5c, 1, 3),  }, 	/* FVco 800.000000 */
+	{ .frequency = 110000000,	.data = PLLVAL(0x66, 1, 3),  }, 	/* FVco 880.000000 */
+	{ .frequency = 120000000,	.data = PLLVAL(0x70, 1, 3),  }, 	/* FVco 960.000000 */
+	{ .frequency = 150000000,	.data = PLLVAL(0x75, 3, 2),  }, 	/* FVco 600.000000 */
+	{ .frequency = 160000000,	.data = PLLVAL(0x98, 4, 2),  }, 	/* FVco 640.000000 */
+	{ .frequency = 170000000,	.data = PLLVAL(0x4d, 1, 2),  }, 	/* FVco 680.000000 */
+	{ .frequency = 180000000,	.data = PLLVAL(0x70, 2, 2),  }, 	/* FVco 720.000000 */
+	{ .frequency = 190000000,	.data = PLLVAL(0x57, 1, 2),  }, 	/* FVco 760.000000 */
+	{ .frequency = 200000000,	.data = PLLVAL(0x5c, 1, 2),  }, 	/* FVco 800.000000 */
+	{ .frequency = 210000000,	.data = PLLVAL(0x84, 2, 2),  }, 	/* FVco 840.000000 */
+	{ .frequency = 220000000,	.data = PLLVAL(0x66, 1, 2),  }, 	/* FVco 880.000000 */
+	{ .frequency = 230000000,	.data = PLLVAL(0x6b, 1, 2),  }, 	/* FVco 920.000000 */
+	{ .frequency = 240000000,	.data = PLLVAL(0x70, 1, 2),  }, 	/* FVco 960.000000 */
+	{ .frequency = 300000000,	.data = PLLVAL(0x75, 3, 1),  }, 	/* FVco 600.000000 */
+	{ .frequency = 310000000,	.data = PLLVAL(0x93, 4, 1),  }, 	/* FVco 620.000000 */
+	{ .frequency = 320000000,	.data = PLLVAL(0x98, 4, 1),  }, 	/* FVco 640.000000 */
+	{ .frequency = 330000000,	.data = PLLVAL(0x66, 2, 1),  }, 	/* FVco 660.000000 */
+	{ .frequency = 340000000,	.data = PLLVAL(0x4d, 1, 1),  }, 	/* FVco 680.000000 */
+	{ .frequency = 350000000,	.data = PLLVAL(0xa7, 4, 1),  }, 	/* FVco 700.000000 */
+	{ .frequency = 360000000,	.data = PLLVAL(0x70, 2, 1),  }, 	/* FVco 720.000000 */
+	{ .frequency = 370000000,	.data = PLLVAL(0xb1, 4, 1),  }, 	/* FVco 740.000000 */
+	{ .frequency = 380000000,	.data = PLLVAL(0x57, 1, 1),  }, 	/* FVco 760.000000 */
+	{ .frequency = 390000000,	.data = PLLVAL(0x7a, 2, 1),  }, 	/* FVco 780.000000 */
+	{ .frequency = 400000000,	.data = PLLVAL(0x5c, 1, 1),  }, 	/* FVco 800.000000 */
 };
 
 static int s3c2440_plls12_add(struct device *dev, struct subsys_interface *sif)
diff --git a/arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c b/arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c
index debfa10..7786b2e 100644
--- a/arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c
+++ b/arch/arm/mach-s3c24xx/pll-s3c2440-16934400.c
@@ -21,61 +21,61 @@
 #include <plat/cpu-freq-core.h>
 
 static struct cpufreq_frequency_table s3c2440_plls_169344[] __initdata = {
-	{ .frequency = 78019200,	.index = PLLVAL(121, 5, 3), 	}, 	/* FVco 624.153600 */
-	{ .frequency = 84067200,	.index = PLLVAL(131, 5, 3), 	}, 	/* FVco 672.537600 */
-	{ .frequency = 90115200,	.index = PLLVAL(141, 5, 3), 	}, 	/* FVco 720.921600 */
-	{ .frequency = 96163200,	.index = PLLVAL(151, 5, 3), 	}, 	/* FVco 769.305600 */
-	{ .frequency = 102135600,	.index = PLLVAL(185, 6, 3), 	}, 	/* FVco 817.084800 */
-	{ .frequency = 108259200,	.index = PLLVAL(171, 5, 3), 	}, 	/* FVco 866.073600 */
-	{ .frequency = 114307200,	.index = PLLVAL(127, 3, 3), 	}, 	/* FVco 914.457600 */
-	{ .frequency = 120234240,	.index = PLLVAL(134, 3, 3), 	}, 	/* FVco 961.873920 */
-	{ .frequency = 126161280,	.index = PLLVAL(141, 3, 3), 	}, 	/* FVco 1009.290240 */
-	{ .frequency = 132088320,	.index = PLLVAL(148, 3, 3), 	}, 	/* FVco 1056.706560 */
-	{ .frequency = 138015360,	.index = PLLVAL(155, 3, 3), 	}, 	/* FVco 1104.122880 */
-	{ .frequency = 144789120,	.index = PLLVAL(163, 3, 3), 	}, 	/* FVco 1158.312960 */
-	{ .frequency = 150100363,	.index = PLLVAL(187, 9, 2), 	}, 	/* FVco 600.401454 */
-	{ .frequency = 156038400,	.index = PLLVAL(121, 5, 2), 	}, 	/* FVco 624.153600 */
-	{ .frequency = 162086400,	.index = PLLVAL(126, 5, 2), 	}, 	/* FVco 648.345600 */
-	{ .frequency = 168134400,	.index = PLLVAL(131, 5, 2), 	}, 	/* FVco 672.537600 */
-	{ .frequency = 174048000,	.index = PLLVAL(177, 7, 2), 	}, 	/* FVco 696.192000 */
-	{ .frequency = 180230400,	.index = PLLVAL(141, 5, 2), 	}, 	/* FVco 720.921600 */
-	{ .frequency = 186278400,	.index = PLLVAL(124, 4, 2), 	}, 	/* FVco 745.113600 */
-	{ .frequency = 192326400,	.index = PLLVAL(151, 5, 2), 	}, 	/* FVco 769.305600 */
-	{ .frequency = 198132480,	.index = PLLVAL(109, 3, 2), 	}, 	/* FVco 792.529920 */
-	{ .frequency = 204271200,	.index = PLLVAL(185, 6, 2), 	}, 	/* FVco 817.084800 */
-	{ .frequency = 210268800,	.index = PLLVAL(141, 4, 2), 	}, 	/* FVco 841.075200 */
-	{ .frequency = 216518400,	.index = PLLVAL(171, 5, 2), 	}, 	/* FVco 866.073600 */
-	{ .frequency = 222264000,	.index = PLLVAL(97, 2, 2), 	}, 	/* FVco 889.056000 */
-	{ .frequency = 228614400,	.index = PLLVAL(127, 3, 2), 	}, 	/* FVco 914.457600 */
-	{ .frequency = 234259200,	.index = PLLVAL(158, 4, 2), 	}, 	/* FVco 937.036800 */
-	{ .frequency = 240468480,	.index = PLLVAL(134, 3, 2), 	}, 	/* FVco 961.873920 */
-	{ .frequency = 246960000,	.index = PLLVAL(167, 4, 2), 	}, 	/* FVco 987.840000 */
-	{ .frequency = 252322560,	.index = PLLVAL(141, 3, 2), 	}, 	/* FVco 1009.290240 */
-	{ .frequency = 258249600,	.index = PLLVAL(114, 2, 2), 	}, 	/* FVco 1032.998400 */
-	{ .frequency = 264176640,	.index = PLLVAL(148, 3, 2), 	}, 	/* FVco 1056.706560 */
-	{ .frequency = 270950400,	.index = PLLVAL(120, 2, 2), 	}, 	/* FVco 1083.801600 */
-	{ .frequency = 276030720,	.index = PLLVAL(155, 3, 2), 	}, 	/* FVco 1104.122880 */
-	{ .frequency = 282240000,	.index = PLLVAL(92, 1, 2), 	}, 	/* FVco 1128.960000 */
-	{ .frequency = 289578240,	.index = PLLVAL(163, 3, 2), 	}, 	/* FVco 1158.312960 */
-	{ .frequency = 294235200,	.index = PLLVAL(131, 2, 2), 	}, 	/* FVco 1176.940800 */
-	{ .frequency = 300200727,	.index = PLLVAL(187, 9, 1), 	}, 	/* FVco 600.401454 */
-	{ .frequency = 306358690,	.index = PLLVAL(191, 9, 1), 	}, 	/* FVco 612.717380 */
-	{ .frequency = 312076800,	.index = PLLVAL(121, 5, 1), 	}, 	/* FVco 624.153600 */
-	{ .frequency = 318366720,	.index = PLLVAL(86, 3, 1), 	}, 	/* FVco 636.733440 */
-	{ .frequency = 324172800,	.index = PLLVAL(126, 5, 1), 	}, 	/* FVco 648.345600 */
-	{ .frequency = 330220800,	.index = PLLVAL(109, 4, 1), 	}, 	/* FVco 660.441600 */
-	{ .frequency = 336268800,	.index = PLLVAL(131, 5, 1), 	}, 	/* FVco 672.537600 */
-	{ .frequency = 342074880,	.index = PLLVAL(93, 3, 1), 	}, 	/* FVco 684.149760 */
-	{ .frequency = 348096000,	.index = PLLVAL(177, 7, 1), 	}, 	/* FVco 696.192000 */
-	{ .frequency = 355622400,	.index = PLLVAL(118, 4, 1), 	}, 	/* FVco 711.244800 */
-	{ .frequency = 360460800,	.index = PLLVAL(141, 5, 1), 	}, 	/* FVco 720.921600 */
-	{ .frequency = 366206400,	.index = PLLVAL(165, 6, 1), 	}, 	/* FVco 732.412800 */
-	{ .frequency = 372556800,	.index = PLLVAL(124, 4, 1), 	}, 	/* FVco 745.113600 */
-	{ .frequency = 378201600,	.index = PLLVAL(126, 4, 1), 	}, 	/* FVco 756.403200 */
-	{ .frequency = 384652800,	.index = PLLVAL(151, 5, 1), 	}, 	/* FVco 769.305600 */
-	{ .frequency = 391608000,	.index = PLLVAL(177, 6, 1), 	}, 	/* FVco 783.216000 */
-	{ .frequency = 396264960,	.index = PLLVAL(109, 3, 1), 	}, 	/* FVco 792.529920 */
-	{ .frequency = 402192000,	.index = PLLVAL(87, 2, 1), 	}, 	/* FVco 804.384000 */
+	{ .frequency = 78019200,	.data = PLLVAL(121, 5, 3), 	}, 	/* FVco 624.153600 */
+	{ .frequency = 84067200,	.data = PLLVAL(131, 5, 3), 	}, 	/* FVco 672.537600 */
+	{ .frequency = 90115200,	.data = PLLVAL(141, 5, 3), 	}, 	/* FVco 720.921600 */
+	{ .frequency = 96163200,	.data = PLLVAL(151, 5, 3), 	}, 	/* FVco 769.305600 */
+	{ .frequency = 102135600,	.data = PLLVAL(185, 6, 3), 	}, 	/* FVco 817.084800 */
+	{ .frequency = 108259200,	.data = PLLVAL(171, 5, 3), 	}, 	/* FVco 866.073600 */
+	{ .frequency = 114307200,	.data = PLLVAL(127, 3, 3), 	}, 	/* FVco 914.457600 */
+	{ .frequency = 120234240,	.data = PLLVAL(134, 3, 3), 	}, 	/* FVco 961.873920 */
+	{ .frequency = 126161280,	.data = PLLVAL(141, 3, 3), 	}, 	/* FVco 1009.290240 */
+	{ .frequency = 132088320,	.data = PLLVAL(148, 3, 3), 	}, 	/* FVco 1056.706560 */
+	{ .frequency = 138015360,	.data = PLLVAL(155, 3, 3), 	}, 	/* FVco 1104.122880 */
+	{ .frequency = 144789120,	.data = PLLVAL(163, 3, 3), 	}, 	/* FVco 1158.312960 */
+	{ .frequency = 150100363,	.data = PLLVAL(187, 9, 2), 	}, 	/* FVco 600.401454 */
+	{ .frequency = 156038400,	.data = PLLVAL(121, 5, 2), 	}, 	/* FVco 624.153600 */
+	{ .frequency = 162086400,	.data = PLLVAL(126, 5, 2), 	}, 	/* FVco 648.345600 */
+	{ .frequency = 168134400,	.data = PLLVAL(131, 5, 2), 	}, 	/* FVco 672.537600 */
+	{ .frequency = 174048000,	.data = PLLVAL(177, 7, 2), 	}, 	/* FVco 696.192000 */
+	{ .frequency = 180230400,	.data = PLLVAL(141, 5, 2), 	}, 	/* FVco 720.921600 */
+	{ .frequency = 186278400,	.data = PLLVAL(124, 4, 2), 	}, 	/* FVco 745.113600 */
+	{ .frequency = 192326400,	.data = PLLVAL(151, 5, 2), 	}, 	/* FVco 769.305600 */
+	{ .frequency = 198132480,	.data = PLLVAL(109, 3, 2), 	}, 	/* FVco 792.529920 */
+	{ .frequency = 204271200,	.data = PLLVAL(185, 6, 2), 	}, 	/* FVco 817.084800 */
+	{ .frequency = 210268800,	.data = PLLVAL(141, 4, 2), 	}, 	/* FVco 841.075200 */
+	{ .frequency = 216518400,	.data = PLLVAL(171, 5, 2), 	}, 	/* FVco 866.073600 */
+	{ .frequency = 222264000,	.data = PLLVAL(97, 2, 2), 	}, 	/* FVco 889.056000 */
+	{ .frequency = 228614400,	.data = PLLVAL(127, 3, 2), 	}, 	/* FVco 914.457600 */
+	{ .frequency = 234259200,	.data = PLLVAL(158, 4, 2), 	}, 	/* FVco 937.036800 */
+	{ .frequency = 240468480,	.data = PLLVAL(134, 3, 2), 	}, 	/* FVco 961.873920 */
+	{ .frequency = 246960000,	.data = PLLVAL(167, 4, 2), 	}, 	/* FVco 987.840000 */
+	{ .frequency = 252322560,	.data = PLLVAL(141, 3, 2), 	}, 	/* FVco 1009.290240 */
+	{ .frequency = 258249600,	.data = PLLVAL(114, 2, 2), 	}, 	/* FVco 1032.998400 */
+	{ .frequency = 264176640,	.data = PLLVAL(148, 3, 2), 	}, 	/* FVco 1056.706560 */
+	{ .frequency = 270950400,	.data = PLLVAL(120, 2, 2), 	}, 	/* FVco 1083.801600 */
+	{ .frequency = 276030720,	.data = PLLVAL(155, 3, 2), 	}, 	/* FVco 1104.122880 */
+	{ .frequency = 282240000,	.data = PLLVAL(92, 1, 2), 	}, 	/* FVco 1128.960000 */
+	{ .frequency = 289578240,	.data = PLLVAL(163, 3, 2), 	}, 	/* FVco 1158.312960 */
+	{ .frequency = 294235200,	.data = PLLVAL(131, 2, 2), 	}, 	/* FVco 1176.940800 */
+	{ .frequency = 300200727,	.data = PLLVAL(187, 9, 1), 	}, 	/* FVco 600.401454 */
+	{ .frequency = 306358690,	.data = PLLVAL(191, 9, 1), 	}, 	/* FVco 612.717380 */
+	{ .frequency = 312076800,	.data = PLLVAL(121, 5, 1), 	}, 	/* FVco 624.153600 */
+	{ .frequency = 318366720,	.data = PLLVAL(86, 3, 1), 	}, 	/* FVco 636.733440 */
+	{ .frequency = 324172800,	.data = PLLVAL(126, 5, 1), 	}, 	/* FVco 648.345600 */
+	{ .frequency = 330220800,	.data = PLLVAL(109, 4, 1), 	}, 	/* FVco 660.441600 */
+	{ .frequency = 336268800,	.data = PLLVAL(131, 5, 1), 	}, 	/* FVco 672.537600 */
+	{ .frequency = 342074880,	.data = PLLVAL(93, 3, 1), 	}, 	/* FVco 684.149760 */
+	{ .frequency = 348096000,	.data = PLLVAL(177, 7, 1), 	}, 	/* FVco 696.192000 */
+	{ .frequency = 355622400,	.data = PLLVAL(118, 4, 1), 	}, 	/* FVco 711.244800 */
+	{ .frequency = 360460800,	.data = PLLVAL(141, 5, 1), 	}, 	/* FVco 720.921600 */
+	{ .frequency = 366206400,	.data = PLLVAL(165, 6, 1), 	}, 	/* FVco 732.412800 */
+	{ .frequency = 372556800,	.data = PLLVAL(124, 4, 1), 	}, 	/* FVco 745.113600 */
+	{ .frequency = 378201600,	.data = PLLVAL(126, 4, 1), 	}, 	/* FVco 756.403200 */
+	{ .frequency = 384652800,	.data = PLLVAL(151, 5, 1), 	}, 	/* FVco 769.305600 */
+	{ .frequency = 391608000,	.data = PLLVAL(177, 6, 1), 	}, 	/* FVco 783.216000 */
+	{ .frequency = 396264960,	.data = PLLVAL(109, 3, 1), 	}, 	/* FVco 792.529920 */
+	{ .frequency = 402192000,	.data = PLLVAL(87, 2, 1), 	}, 	/* FVco 804.384000 */
 };
 
 static int s3c2440_plls169344_add(struct device *dev,
diff --git a/arch/arm/mach-shmobile/clock-sh7372.c b/arch/arm/mach-shmobile/clock-sh7372.c
index 45d21fe..1981c6d 100644
--- a/arch/arm/mach-shmobile/clock-sh7372.c
+++ b/arch/arm/mach-shmobile/clock-sh7372.c
@@ -171,15 +171,15 @@ static void pllc2_table_rebuild(struct clk *clk)
 	/* Initialise PLLC2 frequency table */
 	for (i = 0; i < ARRAY_SIZE(pllc2_freq_table) - 2; i++) {
 		pllc2_freq_table[i].frequency = clk->parent->rate * (i + 20) * 2;
-		pllc2_freq_table[i].index = i;
+		pllc2_freq_table[i].data = i;
 	}
 
 	/* This is a special entry - switching PLL off makes it a repeater */
 	pllc2_freq_table[i].frequency = clk->parent->rate;
-	pllc2_freq_table[i].index = i;
+	pllc2_freq_table[i].data = i;
 
 	pllc2_freq_table[++i].frequency = CPUFREQ_TABLE_END;
-	pllc2_freq_table[i].index = i;
+	pllc2_freq_table[i].data = i;
 }
 
 static unsigned long pllc2_recalc(struct clk *clk)
diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
index d7e1715..126fce4 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
@@ -285,7 +285,7 @@ static inline int s3c_cpufreq_addfreq(struct cpufreq_frequency_table *table,
 		s3c_freq_dbg("%s: { %d = %u kHz }\n",
 			     __func__, index, freq);
 
-		table[index].index = index;
+		table[index].data = index;
 		table[index].frequency = freq;
 	}
 
diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index bc739d4..06edc17 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -121,7 +121,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk->rate = rate;
 
 	regval = LOONGSON_CHIPCFG0;
-	regval = (regval & ~0x7) | (loongson2_clockmod_table[i].index - 1);
+	regval = (regval & ~0x7) | (loongson2_clockmod_table[i].data - 1);
 	LOONGSON_CHIPCFG0 = regval;
 
 	return ret;
diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq.c b/arch/powerpc/platforms/cell/cbe_cpufreq.c
index 718c6a3..1d693c0 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c
+++ b/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -105,7 +105,7 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* initialize frequency table */
 	for (i=0; cbe_freqs[i].frequency!=CPUFREQ_TABLE_END; i++) {
-		cbe_freqs[i].frequency = max_freq / cbe_freqs[i].index;
+		cbe_freqs[i].frequency = max_freq / cbe_freqs[i].data;
 		pr_debug("%d: %d\n", i, cbe_freqs[i].frequency);
 	}
 
@@ -164,7 +164,7 @@ static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 		 "1/%d of max frequency\n",
 		 policy->cpu,
 		 cbe_freqs[cbe_pmode_new].frequency,
-		 cbe_freqs[cbe_pmode_new].index);
+		 cbe_freqs[cbe_pmode_new].data);
 
 	rc = set_pmode(policy->cpu, cbe_pmode_new);
 
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 32ee0fc..08f9fb1 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -647,14 +647,14 @@ int opp_init_cpufreq_table(struct device *dev,
 
 	list_for_each_entry(opp, &dev_opp->opp_list, node) {
 		if (opp->available) {
-			freq_table[i].index = i;
+			freq_table[i].data = i;
 			freq_table[i].frequency = opp->rate / 1000;
 			i++;
 		}
 	}
 	mutex_unlock(&dev_opp_list_lock);
 
-	freq_table[i].index = i;
+	freq_table[i].data = i;
 	freq_table[i].frequency = CPUFREQ_TABLE_END;
 
 	*table = &freq_table[0];
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 11b8b4b..ce28c34 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -232,7 +232,7 @@ static unsigned extract_msr(u32 msr, struct acpi_cpufreq_data *data)
 	perf = data->acpi_data;
 
 	for (i = 0; data->freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (msr == perf->states[data->freq_table[i].index].status)
+		if (msr == perf->states[data->freq_table[i].data].status)
 			return data->freq_table[i].frequency;
 	}
 	return data->freq_table[0].frequency;
@@ -442,7 +442,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	next_perf_state = data->freq_table[next_state].index;
+	next_perf_state = data->freq_table[next_state].data;
 	if (perf->state == next_perf_state) {
 		if (unlikely(data->resume)) {
 			pr_debug("Called after resume, resetting to P%d\n",
@@ -811,7 +811,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		    data->freq_table[valid_states-1].frequency / 1000)
 			continue;
 
-		data->freq_table[valid_states].index = i;
+		data->freq_table[valid_states].data = i;
 		data->freq_table[valid_states].frequency =
 		    perf->states[i].core_frequency * 1000;
 		valid_states++;
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 995511e80..03857f1 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -20,23 +20,23 @@
 
 
 /* this is the table of CCLK frequencies, in Hz */
-/* .index is the entry in the auxiliary dpm_state_table[] */
+/* .data is the entry in the auxiliary dpm_state_table[] */
 static struct cpufreq_frequency_table bfin_freq_table[] = {
 	{
 		.frequency = CPUFREQ_TABLE_END,
-		.index = 0,
+		.data = 0,
 	},
 	{
 		.frequency = CPUFREQ_TABLE_END,
-		.index = 1,
+		.data = 1,
 	},
 	{
 		.frequency = CPUFREQ_TABLE_END,
-		.index = 2,
+		.data = 2,
 	},
 	{
 		.frequency = CPUFREQ_TABLE_END,
-		.index = 0,
+		.data = 0,
 	},
 };
 
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 37380fb..7cc03b7 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -188,7 +188,7 @@ static int eps_target(struct cpufreq_policy *policy,
 	}
 
 	/* Make frequency transition */
-	dest_state = centaur->freq_table[newstate].index & 0xffff;
+	dest_state = centaur->freq_table[newstate].data & 0xffff;
 	ret = eps_set_state(centaur, policy, dest_state);
 	if (ret)
 		printk(KERN_ERR "eps: Timeout!\n");
@@ -380,9 +380,9 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	f_table = &centaur->freq_table[0];
 	if (brand != EPS_BRAND_C7M) {
 		f_table[0].frequency = fsb * min_multiplier;
-		f_table[0].index = (min_multiplier << 8) | min_voltage;
+		f_table[0].data = (min_multiplier << 8) | min_voltage;
 		f_table[1].frequency = fsb * max_multiplier;
-		f_table[1].index = (max_multiplier << 8) | max_voltage;
+		f_table[1].data = (max_multiplier << 8) | max_voltage;
 		f_table[2].frequency = CPUFREQ_TABLE_END;
 	} else {
 		k = 0;
@@ -391,7 +391,7 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		for (i = min_multiplier; i <= max_multiplier; i++) {
 			voltage = (k * step) / 256 + min_voltage;
 			f_table[k].frequency = fsb * i;
-			f_table[k].index = (i << 8) | voltage;
+			f_table[k].data = (i << 8) | voltage;
 			k++;
 		}
 		f_table[k].frequency = CPUFREQ_TABLE_END;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index d7a7966..c17a605 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -34,8 +34,8 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 			continue;
 		}
-		pr_debug("table entry %u: %u kHz, %u index\n",
-					i, freq, table[i].index);
+		pr_debug("table entry %u: %u kHz, %u data\n",
+					i, freq, table[i].data);
 		if (freq < min_freq)
 			min_freq = freq;
 		if (freq > max_freq)
@@ -97,11 +97,11 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int *index)
 {
 	struct cpufreq_frequency_table optimal = {
-		.index = ~0,
+		.data = ~0,
 		.frequency = 0,
 	};
 	struct cpufreq_frequency_table suboptimal = {
-		.index = ~0,
+		.data = ~0,
 		.frequency = 0,
 	};
 	unsigned int i;
@@ -129,12 +129,12 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 			if (freq <= target_freq) {
 				if (freq >= optimal.frequency) {
 					optimal.frequency = freq;
-					optimal.index = i;
+					optimal.data = i;
 				}
 			} else {
 				if (freq <= suboptimal.frequency) {
 					suboptimal.frequency = freq;
-					suboptimal.index = i;
+					suboptimal.data = i;
 				}
 			}
 			break;
@@ -142,26 +142,26 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 			if (freq >= target_freq) {
 				if (freq <= optimal.frequency) {
 					optimal.frequency = freq;
-					optimal.index = i;
+					optimal.data = i;
 				}
 			} else {
 				if (freq >= suboptimal.frequency) {
 					suboptimal.frequency = freq;
-					suboptimal.index = i;
+					suboptimal.data = i;
 				}
 			}
 			break;
 		}
 	}
-	if (optimal.index > i) {
-		if (suboptimal.index > i)
+	if (optimal.data > i) {
+		if (suboptimal.data > i)
 			return -EINVAL;
-		*index = suboptimal.index;
+		*index = suboptimal.data;
 	} else
-		*index = optimal.index;
+		*index = optimal.data;
 
 	pr_debug("target is %u (%u kHz, %u)\n", *index, table[*index].frequency,
-		table[*index].index);
+		table[*index].data);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index c0075db..b8e8536 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -326,7 +326,7 @@ acpi_cpufreq_cpu_init (
 	/* table init */
 	for (i = 0; i <= data->acpi_data.state_count; i++)
 	{
-		data->freq_table[i].index = i;
+		data->freq_table[i].data = i;
 		if (i < data->acpi_data.state_count) {
 			data->freq_table[i].frequency =
 			      data->acpi_data.states[i].core_frequency * 1000;
diff --git a/drivers/cpufreq/imx-cpufreq.c b/drivers/cpufreq/imx-cpufreq.c
index 20250b4..3017118 100644
--- a/drivers/cpufreq/imx-cpufreq.c
+++ b/drivers/cpufreq/imx-cpufreq.c
@@ -129,7 +129,7 @@ static int mxc_cpufreq_init(struct cpufreq_policy *policy)
 	}
 
 	for (i = 0; i < cpu_op_nr; i++) {
-		imx_freq_table[i].index = i;
+		imx_freq_table[i].data = i;
 		imx_freq_table[i].frequency = cpu_op_tbl[i].cpu_rate / 1000;
 
 		if ((cpu_op_tbl[i].cpu_rate / 1000) < cpu_freq_khz_min)
@@ -139,7 +139,7 @@ static int mxc_cpufreq_init(struct cpufreq_policy *policy)
 			cpu_freq_khz_max = cpu_op_tbl[i].cpu_rate / 1000;
 	}
 
-	imx_freq_table[i].index = i;
+	imx_freq_table[i].data = i;
 	imx_freq_table[i].frequency = CPUFREQ_TABLE_END;
 
 	policy->cur = clk_get_rate(cpu_clk) / 1000;
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index d36ea8d..7fdc677 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -59,7 +59,7 @@ static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
 		unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int state = kirkwood_freq_table[index].index;
+	unsigned int state = kirkwood_freq_table[index].data;
 	unsigned long reg;
 
 	freqs.old = kirkwood_cpufreq_get_cpu_frequency(0);
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index b448638..95e56bd 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -254,7 +254,7 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
 	u32 bm_timeout = 1000;
 	unsigned int dir = 0;
 
-	mults_index = longhaul_table[table_index].index;
+	mults_index = longhaul_table[table_index].data;
 	/* Safety precautions */
 	mult = mults[mults_index & 0x1f];
 	if (mult == -1)
@@ -487,7 +487,7 @@ static int __cpuinit longhaul_get_ranges(void)
 		if (ratio > maxmult || ratio < minmult)
 			continue;
 		longhaul_table[k].frequency = calc_speed(ratio);
-		longhaul_table[k].index	= j;
+		longhaul_table[k].data	= j;
 		k++;
 	}
 	if (k <= 1) {
@@ -508,8 +508,8 @@ static int __cpuinit longhaul_get_ranges(void)
 		if (min_i != j) {
 			swap(longhaul_table[j].frequency,
 			     longhaul_table[min_i].frequency);
-			swap(longhaul_table[j].index,
-			     longhaul_table[min_i].index);
+			swap(longhaul_table[j].data,
+			     longhaul_table[min_i].data);
 		}
 	}
 
@@ -517,7 +517,7 @@ static int __cpuinit longhaul_get_ranges(void)
 
 	/* Find index we are running on */
 	for (j = 0; j < k; j++) {
-		if (mults[longhaul_table[j].index & 0x1f] == mult) {
+		if (mults[longhaul_table[j].data & 0x1f] == mult) {
 			longhaul_index = j;
 			break;
 		}
@@ -613,7 +613,7 @@ static void __cpuinit longhaul_setup_voltagescaling(void)
 			pos = (speed - min_vid_speed) / kHz_step + minvid.pos;
 		else
 			pos = minvid.pos;
-		longhaul_table[j].index |= mV_vrm_table[pos] << 8;
+		longhaul_table[j].data |= mV_vrm_table[pos] << 8;
 		vid = vrm_mV_table[mV_vrm_table[pos]];
 		printk(KERN_INFO PFX "f: %d kHz, index: %d, vid: %d mV\n",
 				speed, j, vid.mV);
@@ -656,12 +656,12 @@ static int longhaul_target(struct cpufreq_policy *policy,
 		 * this in hardware, C3 is old and we need to do this
 		 * in software. */
 		i = longhaul_index;
-		current_vid = (longhaul_table[longhaul_index].index >> 8);
+		current_vid = (longhaul_table[longhaul_index].data >> 8);
 		current_vid &= 0x1f;
 		if (table_index > longhaul_index)
 			dir = 1;
 		while (i != table_index) {
-			vid = (longhaul_table[i].index >> 8) & 0x1f;
+			vid = (longhaul_table[i].data >> 8) & 0x1f;
 			if (vid != current_vid) {
 				longhaul_setstate(policy, i);
 				current_vid = vid;
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index 8488957..d9ae287 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -71,7 +71,7 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 
 	freq =
 	    ((cpu_clock_freq / 1000) *
-	     loongson2_clockmod_table[newstate].index) / 8;
+	     loongson2_clockmod_table[newstate].data) / 8;
 	if (freq < policy->min || freq > policy->max)
 		return -EINVAL;
 
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 421ef37..6d69901 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -118,7 +118,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 		return -EINVAL;
 
 	freqs.old = cpufreq_p4_get(policy->cpu);
-	freqs.new = stock_freq * p4clockmod_table[newstate].index / 8;
+	freqs.new = stock_freq * p4clockmod_table[newstate].data / 8;
 
 	if (freqs.new == freqs.old)
 		return 0;
@@ -131,7 +131,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	 * Developer's Manual, Volume 3
 	 */
 	for_each_cpu(i, policy->cpus)
-		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
+		cpufreq_p4_setdc(i, p4clockmod_table[newstate].data);
 
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index be1e795..3786e2b 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -204,7 +204,7 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* initialize frequency table */
 	for (i=0; pas_freqs[i].frequency!=CPUFREQ_TABLE_END; i++) {
-		pas_freqs[i].frequency = get_astate_freq(pas_freqs[i].index) * 100000;
+		pas_freqs[i].frequency = get_astate_freq(pas_freqs[i].data) * 100000;
 		pr_debug("%d: %d\n", i, pas_freqs[i].frequency);
 	}
 
@@ -280,7 +280,7 @@ static int pas_cpufreq_target(struct cpufreq_policy *policy,
 	pr_debug("setting frequency for cpu %d to %d kHz, 1/%d of max frequency\n",
 		 policy->cpu,
 		 pas_freqs[pas_astate_new].frequency,
-		 pas_freqs[pas_astate_new].index);
+		 pas_freqs[pas_astate_new].data);
 
 	current_astate = pas_astate_new;
 
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ea0222a..3b9f74d 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -58,7 +58,7 @@ static int powernow_k6_get_cpu_multiplier(void)
 	msrval = POWERNOW_IOPORT + 0x0;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
-	return clock_ratio[(invalue >> 5)&7].index;
+	return clock_ratio[(invalue >> 5)&7].data;
 }
 
 
@@ -75,13 +75,13 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
 	unsigned long msrval;
 	struct cpufreq_freqs freqs;
 
-	if (clock_ratio[best_i].index > max_multiplier) {
+	if (clock_ratio[best_i].data > max_multiplier) {
 		printk(KERN_ERR PFX "invalid target frequency\n");
 		return;
 	}
 
 	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
-	freqs.new = busfreq * clock_ratio[best_i].index;
+	freqs.new = busfreq * clock_ratio[best_i].data;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -156,7 +156,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 
 	/* table init */
 	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
-		f = clock_ratio[i].index;
+		f = clock_ratio[i].data;
 		if (f > max_multiplier)
 			clock_ratio[i].frequency = CPUFREQ_ENTRY_INVALID;
 		else
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 53888da..cffe828 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -186,7 +186,7 @@ static int get_ranges(unsigned char *pst)
 		fid = *pst++;
 
 		powernow_table[j].frequency = (fsb * fid_codes[fid]) / 10;
-		powernow_table[j].index = fid; /* lower 8 bits */
+		powernow_table[j].data = fid; /* lower 8 bits */
 
 		speed = powernow_table[j].frequency;
 
@@ -203,7 +203,7 @@ static int get_ranges(unsigned char *pst)
 			maximum_speed = speed;
 
 		vid = *pst++;
-		powernow_table[j].index |= (vid << 8); /* upper 8 bits */
+		powernow_table[j].data |= (vid << 8); /* upper 8 bits */
 
 		pr_debug("   FID: 0x%x (%d.%dx [%dMHz])  "
 			 "VID: 0x%x (%d.%03dV)\n", fid, fid_codes[fid] / 10,
@@ -212,7 +212,7 @@ static int get_ranges(unsigned char *pst)
 			 mobile_vid_table[vid]%1000);
 	}
 	powernow_table[number_scales].frequency = CPUFREQ_TABLE_END;
-	powernow_table[number_scales].index = 0;
+	powernow_table[number_scales].data = 0;
 
 	return 0;
 }
@@ -260,8 +260,8 @@ static void change_speed(struct cpufreq_policy *policy, unsigned int index)
 	 * vid are the upper 8 bits.
 	 */
 
-	fid = powernow_table[index].index & 0xFF;
-	vid = (powernow_table[index].index & 0xFF00) >> 8;
+	fid = powernow_table[index].data & 0xFF;
+	vid = (powernow_table[index].data & 0xFF00) >> 8;
 
 	rdmsrl(MSR_K7_FID_VID_STATUS, fidvidstatus.val);
 	cfid = fidvidstatus.bits.CFID;
@@ -373,8 +373,8 @@ static int powernow_acpi_init(void)
 		fid = pc.bits.fid;
 
 		powernow_table[i].frequency = fsb * fid_codes[fid] / 10;
-		powernow_table[i].index = fid; /* lower 8 bits */
-		powernow_table[i].index |= (vid << 8); /* upper 8 bits */
+		powernow_table[i].data = fid; /* lower 8 bits */
+		powernow_table[i].data |= (vid << 8); /* upper 8 bits */
 
 		speed = powernow_table[i].frequency;
 		speed_mhz = speed / 1000;
@@ -417,7 +417,7 @@ static int powernow_acpi_init(void)
 	}
 
 	powernow_table[i].frequency = CPUFREQ_TABLE_END;
-	powernow_table[i].index = 0;
+	powernow_table[i].data = 0;
 
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index b828efe..6865266 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -584,9 +584,9 @@ static void print_basics(struct powernow_k8_data *data)
 				CPUFREQ_ENTRY_INVALID) {
 				printk(KERN_INFO PFX
 					"fid 0x%x (%d MHz), vid 0x%x\n",
-					data->powernow_table[j].index & 0xff,
+					data->powernow_table[j].data & 0xff,
 					data->powernow_table[j].frequency/1000,
-					data->powernow_table[j].index >> 8);
+					data->powernow_table[j].data >> 8);
 		}
 	}
 	if (data->batps)
@@ -632,13 +632,13 @@ static int fill_powernow_table(struct powernow_k8_data *data,
 
 	for (j = 0; j < data->numps; j++) {
 		int freq;
-		powernow_table[j].index = pst[j].fid; /* lower 8 bits */
-		powernow_table[j].index |= (pst[j].vid << 8); /* upper 8 bits */
+		powernow_table[j].data = pst[j].fid; /* lower 8 bits */
+		powernow_table[j].data |= (pst[j].vid << 8); /* upper 8 bits */
 		freq = find_khz_freq_from_fid(pst[j].fid);
 		powernow_table[j].frequency = freq;
 	}
 	powernow_table[data->numps].frequency = CPUFREQ_TABLE_END;
-	powernow_table[data->numps].index = 0;
+	powernow_table[data->numps].data = 0;
 
 	if (query_current_values_with_pending_wait(data)) {
 		kfree(powernow_table);
@@ -810,7 +810,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 
 	powernow_table[data->acpi_data.state_count].frequency =
 		CPUFREQ_TABLE_END;
-	powernow_table[data->acpi_data.state_count].index = 0;
+	powernow_table[data->acpi_data.state_count].data = 0;
 	data->powernow_table = powernow_table;
 
 	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
@@ -865,7 +865,7 @@ static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
 		pr_debug("   %d : fid 0x%x, vid 0x%x\n", i, fid, vid);
 
 		index = fid | (vid<<8);
-		powernow_table[i].index = index;
+		powernow_table[i].data = index;
 
 		freq = find_khz_freq_from_fid(fid);
 		powernow_table[i].frequency = freq;
@@ -941,8 +941,8 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	 * the cpufreq frequency table in find_psb_table, vid
 	 * are the upper 8 bits.
 	 */
-	fid = data->powernow_table[index].index & 0xFF;
-	vid = (data->powernow_table[index].index & 0xFF00) >> 8;
+	fid = data->powernow_table[index].data & 0xFF;
+	vid = (data->powernow_table[index].data & 0xFF00) >> 8;
 
 	pr_debug("table matched fid 0x%x, giving vid 0x%x\n", fid, vid);
 
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index fe4c55b..d2469e7 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -419,7 +419,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 	/* Generate pxa25x the run cpufreq_frequency_table struct */
 	for (i = 0; i < NUM_PXA25x_RUN_FREQS; i++) {
 		pxa255_run_freq_table[i].frequency = pxa255_run_freqs[i].khz;
-		pxa255_run_freq_table[i].index = i;
+		pxa255_run_freq_table[i].data = i;
 	}
 	pxa255_run_freq_table[i].frequency = CPUFREQ_TABLE_END;
 
@@ -427,7 +427,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 	for (i = 0; i < NUM_PXA25x_TURBO_FREQS; i++) {
 		pxa255_turbo_freq_table[i].frequency =
 			pxa255_turbo_freqs[i].khz;
-		pxa255_turbo_freq_table[i].index = i;
+		pxa255_turbo_freq_table[i].data = i;
 	}
 	pxa255_turbo_freq_table[i].frequency = CPUFREQ_TABLE_END;
 
@@ -439,9 +439,9 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		if (freq > pxa27x_maxfreq)
 			break;
 		pxa27x_freq_table[i].frequency = freq;
-		pxa27x_freq_table[i].index = i;
+		pxa27x_freq_table[i].data = i;
 	}
-	pxa27x_freq_table[i].index = i;
+	pxa27x_freq_table[i].data = i;
 	pxa27x_freq_table[i].frequency = CPUFREQ_TABLE_END;
 
 	/*
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 15d60f8..adaa78b 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -98,10 +98,10 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 		return -ENOMEM;
 
 	for (i = 0; i < num; i++) {
-		table[i].index = i;
+		table[i].data = i;
 		table[i].frequency = freqs[i].cpufreq_mhz * 1000;
 	}
-	table[num].index = i;
+	table[num].data = i;
 	table[num].frequency = CPUFREQ_TABLE_END;
 
 	pxa3xx_freqs = freqs;
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4f1881e..0c17fe7 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -244,7 +244,7 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 	if (ret != 0)
 		goto out;
 
-	idx = s3c_freq->freq_table[i].index;
+	idx = s3c_freq->freq_table[i].data;
 
 	if (idx == SOURCE_HCLK)
 		to_dvs = 1;
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 27cacb5..240d5c8 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -87,7 +87,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	freqs.old = clk_get_rate(armclk) / 1000;
 	freqs.new = s3c64xx_freq_table[i].frequency;
 	freqs.flags = 0;
-	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[i].index];
+	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[i].data];
 
 	if (freqs.old == freqs.new)
 		return 0;
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index f740b13..edf7b2d 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -71,7 +71,7 @@ static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_disable();
 
 	clockspeed_reg = *cpuctl & ~0x03;
-	*cpuctl = clockspeed_reg | sc520_freq_table[state].index;
+	*cpuctl = clockspeed_reg | sc520_freq_table[state].data;
 
 	local_irq_enable();
 
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 306ae46..216e166 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -308,17 +308,17 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	struct cpufreq_frequency_table *table =
 		&us2e_freq_table[cpu].table[0];
 
-	table[0].index = 0;
+	table[0].data = 0;
 	table[0].frequency = clock_tick / 1;
-	table[1].index = 1;
+	table[1].data = 1;
 	table[1].frequency = clock_tick / 2;
-	table[2].index = 2;
+	table[2].data = 2;
 	table[2].frequency = clock_tick / 4;
-	table[2].index = 3;
+	table[2].data = 3;
 	table[2].frequency = clock_tick / 6;
-	table[2].index = 4;
+	table[2].data = 4;
 	table[2].frequency = clock_tick / 8;
-	table[2].index = 5;
+	table[2].data = 5;
 	table[3].frequency = CPUFREQ_TABLE_END;
 
 	policy->cpuinfo.transition_latency = 0;
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index c71ee14..9889b8e 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -169,13 +169,13 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	struct cpufreq_frequency_table *table =
 		&us3_freq_table[cpu].table[0];
 
-	table[0].index = 0;
+	table[0].data = 0;
 	table[0].frequency = clock_tick / 1;
-	table[1].index = 1;
+	table[1].data = 1;
 	table[1].frequency = clock_tick / 2;
-	table[2].index = 2;
+	table[2].data = 2;
 	table[2].frequency = clock_tick / 32;
-	table[3].index = 0;
+	table[3].data = 0;
 	table[3].frequency = CPUFREQ_TABLE_END;
 
 	policy->cpuinfo.transition_latency = 0;
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 156829f..ec448bfc 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -250,11 +250,11 @@ static int spear_cpufreq_driver_init(void)
 	}
 
 	for (i = 0; i < cnt; i++) {
-		freq_tbl[i].index = i;
+		freq_tbl[i].data = i;
 		freq_tbl[i].frequency = be32_to_cpup(val++);
 	}
 
-	freq_tbl[i].index = i;
+	freq_tbl[i].data = i;
 	freq_tbl[i].frequency = CPUFREQ_TABLE_END;
 
 	spear_cpufreq.freq_tbl = freq_tbl;
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 618e6f4..fcfa2f8 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -79,11 +79,11 @@ static struct cpufreq_driver centrino_driver;
 
 /* Computes the correct form for IA32_PERF_CTL MSR for a particular
    frequency/voltage operating point; frequency in MHz, volts in mV.
-   This is stored as "index" in the structure. */
+   This is stored as "data" in the structure. */
 #define OP(mhz, mv)							\
 	{								\
 		.frequency = (mhz) * 1000,				\
-		.index = (((mhz)/100) << 8) | ((mv - 700) / 16)		\
+		.data = (((mhz)/100) << 8) | ((mv - 700) / 16)		\
 	}
 
 /*
@@ -307,7 +307,7 @@ static unsigned extract_clock(unsigned msr, unsigned int cpu, int failsafe)
 		per_cpu(centrino_model, cpu)->op_points[i].frequency
 							!= CPUFREQ_TABLE_END;
 	     i++) {
-		if (msr == per_cpu(centrino_model, cpu)->op_points[i].index)
+		if (msr == per_cpu(centrino_model, cpu)->op_points[i].data)
 			return per_cpu(centrino_model, cpu)->
 							op_points[i].frequency;
 	}
@@ -501,7 +501,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 		}
 
-		msr = per_cpu(centrino_model, cpu)->op_points[newstate].index;
+		msr = per_cpu(centrino_model, cpu)->op_points[newstate].data;
 
 		if (first_cpu) {
 			rdmsr_on_cpu(good_cpu, MSR_IA32_PERF_CTL, &oldmsr, &h);
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index c74c0e1..fca6184 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -28,7 +28,7 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
-/* Frequency table index must be sequential starting at 0 */
+/* Frequency table data must be sequential starting at 0 */
 static struct cpufreq_frequency_table freq_table[] = {
 	{ 0, 216000 },
 	{ 1, 312000 },
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 21f261b..e210ff1 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1810,9 +1810,9 @@ static long round_clock_rate(u8 clock, unsigned long rate)
 
 /* CPU FREQ table, may be changed due to if MAX_OPP is supported. */
 static struct cpufreq_frequency_table db8500_cpufreq_table[] = {
-	{ .frequency = 200000, .index = ARM_EXTCLK,},
-	{ .frequency = 400000, .index = ARM_50_OPP,},
-	{ .frequency = 800000, .index = ARM_100_OPP,},
+	{ .frequency = 200000, .data = ARM_EXTCLK,},
+	{ .frequency = 400000, .data = ARM_50_OPP,},
+	{ .frequency = 800000, .data = ARM_100_OPP,},
 	{ .frequency = CPUFREQ_TABLE_END,}, /* To be used for MAX_OPP. */
 	{ .frequency = CPUFREQ_TABLE_END,},
 };
@@ -1987,7 +1987,7 @@ static int set_armss_rate(unsigned long rate)
 		return -EINVAL;
 
 	/* Set the new arm opp. */
-	return db8500_prcmu_set_arm_opp(db8500_cpufreq_table[i].index);
+	return db8500_prcmu_set_arm_opp(db8500_cpufreq_table[i].data);
 }
 
 static int set_plldsi_rate(unsigned long rate)
@@ -3137,7 +3137,7 @@ static void db8500_prcmu_update_cpufreq(void)
 {
 	if (prcmu_has_arm_maxopp()) {
 		db8500_cpufreq_table[3].frequency = 1000000;
-		db8500_cpufreq_table[3].index = ARM_MAX_OPP;
+		db8500_cpufreq_table[3].data = ARM_MAX_OPP;
 	}
 }
 
diff --git a/drivers/sh/clk/core.c b/drivers/sh/clk/core.c
index 7715de2..bc48116 100644
--- a/drivers/sh/clk/core.c
+++ b/drivers/sh/clk/core.c
@@ -63,12 +63,12 @@ void clk_rate_table_build(struct clk *clk,
 		else
 			freq = clk->parent->rate * mult / div;
 
-		freq_table[i].index = i;
+		freq_table[i].data = i;
 		freq_table[i].frequency = freq;
 	}
 
 	/* Termination entry */
-	freq_table[i].index = i;
+	freq_table[i].data = i;
 	freq_table[i].frequency = CPUFREQ_TABLE_END;
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..aa0c2a3 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -404,7 +404,7 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_TABLE_END     ~1
 
 struct cpufreq_frequency_table {
-	unsigned int	index;     /* any */
+	unsigned int	data;     /* any value, not used by core */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
 				    * order */
 };
-- 
1.7.12.rc2.18.g61b472e

