Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab3DDM7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:59:17 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61026 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760848Ab3DDM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:56:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 11/18] cpufreq: cris: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:19 +0530
Message-Id: <c9222567062448d604994ab706db0f047a5ffd47.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq drivers of CRIS architecture to drivers/cpufreq.

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
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
index 19de776..751815d 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -84,3 +84,5 @@ obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
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

