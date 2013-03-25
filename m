Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3CYQzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:55:33 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44032 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3CYQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:55:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 3/9] cris: cpufreq:  move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 22:24:39 +0530
Message-Id: <ba21f31410c122d160698a6d18266e3f695f6011.1364229828.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq drivers of CRIS architecture to drivers/cpufreq.

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/cris/arch-v32/mach-a3/Makefile                                     | 1 -
 arch/cris/arch-v32/mach-fs/Makefile                                     | 1 -
 drivers/cpufreq/Makefile                                                | 2 ++
 .../mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c         | 0
 .../mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c         | 0
 5 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/cris/arch-v32/mach-a3/cpufreq.c => drivers/cpufreq/cris-artpec3-cpufreq.c (100%)
 rename arch/cris/arch-v32/mach-fs/cpufreq.c => drivers/cpufreq/cris-etraxfs-cpufreq.c (100%)

diff --git a/arch/cris/arch-v32/mach-a3/Makefile b/arch/cris/arch-v32/mach-a3/Makefile
index d366e08..18a2271 100644
--- a/arch/cris/arch-v32/mach-a3/Makefile
+++ b/arch/cris/arch-v32/mach-a3/Makefile
@@ -3,7 +3,6 @@
 #
 
 obj-y   := dma.o pinmux.o io.o arbiter.o
-obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
 
 clean:
 
diff --git a/arch/cris/arch-v32/mach-fs/Makefile b/arch/cris/arch-v32/mach-fs/Makefile
index d366e08..18a2271 100644
--- a/arch/cris/arch-v32/mach-fs/Makefile
+++ b/arch/cris/arch-v32/mach-fs/Makefile
@@ -3,7 +3,6 @@
 #
 
 obj-y   := dma.o pinmux.o io.o arbiter.o
-obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
 
 clean:
 
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 2d86377..8fbfbbf 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -80,3 +80,5 @@ obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
 # Other platform drivers
 obj-$(CONFIG_AVR32_AT32AP_CPUFREQ)	+= at32ap-cpufreq.o
 obj-$(CONFIG_BLACKFIN)			+= blackfin-cpufreq.o
+obj-$(CONFIG_CRIS_MACH_ARTPEC3)		+= cris-artpec3-cpufreq.o
+obj-$(CONFIG_ETRAXFS)			+= cris-etraxfs-cpufreq.o
diff --git a/arch/cris/arch-v32/mach-a3/cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
similarity index 100%
rename from arch/cris/arch-v32/mach-a3/cpufreq.c
rename to drivers/cpufreq/cris-artpec3-cpufreq.c
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
similarity index 100%
rename from arch/cris/arch-v32/mach-fs/cpufreq.c
rename to drivers/cpufreq/cris-etraxfs-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

