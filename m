Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3EaWZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3EaWXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH 07/15] cpufreq: spear needs cpufreq table
Date: Sat,  1 Jun 2013 00:22:44 +0200
Message-Id: <1370038972-2318779-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jD+xxOhrSFf+EpNXXvONBTHfcD4FG23mgZULwuGBTdx
 n8B+0CY7JvWKO47L/2bs5lba2RVCmCFiLlQxwI49RIkphD8U2/
 /h6pry5mE1FQzQ2R2p+oOVOgEudCG8myZQw2ShgAar4D8aiKjA
 iS0zQVKmQisFTqk0E5fskqlpqIbAMNiP0RH988Pw4ubJXHTPB+
 YstrhDUCJXnkNieJt2tazE3J9wAEWfIgFbKBdjGkvo1io9RZ23
 dLB7Ge8nNi7PLFq8fVp7awrxraXoevJhpWMC9uo8oK+fN8SHMR
 EhmWEwcXqU/quelAveDIR9Y0pRR/XTSrklAgKew47gWs/mI0Nk
 Zs4r89NrdGrFBUQ4vwwZbAgzk11IYj0tD+v1GPSQJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like a lot of the other cpufreq drivers, this one needs to
select CONFIG_CPU_FREQ_TABLE to avoid a build error like

drivers/built-in.o: In function `spear_cpufreq_exit':
spear-cpufreq.c:198: undefined reference to `cpufreq_frequency_table_put_attr'
drivers/built-in.o: In function `spear_cpufreq_verify':
spear-cpufreq.c:35: undefined reference to `cpufreq_frequency_table_verify'
drivers/built-in.o: In function `spear_cpufreq_init':
spear-cpufreq.c:181: undefined reference to `cpufreq_frequency_table_cpuinfo'
spear-cpufreq.c:187: undefined reference to `cpufreq_frequency_table_get_attr'
drivers/built-in.o: In function `spear_cpufreq_target':
spear-cpufreq.c:120: undefined reference to `cpufreq_frequency_table_target'
drivers/built-in.o:(.data+0x5e63c): undefined reference to `cpufreq_freq_attr_scaling_available_freqs'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org
Cc: linux-pm@vger.kernel.org
---
 drivers/cpufreq/Kconfig.arm | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index a924408..d3f2c6b 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -205,6 +205,7 @@ config ARM_SA1110_CPUFREQ
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR
+	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
-- 
1.8.1.2

