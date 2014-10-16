Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaJPK0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:26:10 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39575 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaJPKUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:21 -0400
From: James Geboski <jgeboski@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Geboski <jgeboski@gmail.com>
Subject: [PATCH] cpufreq: allow powersave governor as the default without expert mode
Date: Thu, 16 Oct 2014 06:20:04 -0400
Message-Id: <1413454804-19370-1-git-send-email-jgeboski@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intel_pstate driver only supports the performance and the powersave
governors. With the performance governor ensuring the highest possible
performance settings, userspace tools fail to make any lasting changes.
In order to allow userspace tools to make modifications to the settings,
the powersave governor must be in use. This makes having the powersave
governor as the default convenient for systems where the intel_pstate
driver is being employed. Having to enable expert mode in the kernel
configuration is just a headache for such a trivial task.

This patch applies to all kernel versions 2.6.38 or greater after the
migration from CONFIG_EMBEDDED to CONFIG_EXPERT (6a108a14fa35). Most
importantly, this applies to kernel versions 3.9 or greater when the
intel_pstate driver was introduced.

Signed-off-by: James Geboski <jgeboski@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 3489f8f..73df7db 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -63,7 +63,6 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 
 config CPU_FREQ_DEFAULT_GOV_POWERSAVE
 	bool "powersave"
-	depends on EXPERT
 	select CPU_FREQ_GOV_POWERSAVE
 	help
 	  Use the CPUFreq governor 'powersave' as default. This sets
-- 
2.1.2

