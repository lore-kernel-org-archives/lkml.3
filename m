Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273Ab3BMUPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:15:03 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:57173 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab3BMUPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:15:00 -0500
From: dirk.brandewie@gmail.com
To: davej@redhat.com, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH] cpufreq/intel_pstate: Change to disallow module build
Date: Wed, 13 Feb 2013 12:14:42 -0800
Message-Id: <1360786482-881-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360786482-881-1-git-send-email-dirk.brandewie@gmail.com>
References: <20130212214949.GA1003@redhat.com>
 <1360786482-881-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Load order is important in order for intel_pstate to take over as the
default scaling driver from acpi-cpufreq.

If both are built-in acpi-cpufreq uses late_initcall() and
intel_pstate uses device_initcall() so it will be able to register as
the scaling before acpi-cpufreq for the processors supported by
intel_pstate.

If acpi-cpufreq is built as a module then intel_pstate still gets
first option to become the scaling driver.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/cpufreq/Kconfig.x86 |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 6aa7053..98e5abb 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -3,7 +3,7 @@
 #
 
 config X86_INTEL_PSTATE
-       tristate "Intel P state control"
+       bool "Intel P state control"
        depends on X86
        help
           This driver provides a P state for Intel core processors.
@@ -13,11 +13,6 @@ config X86_INTEL_PSTATE
 	  When this driver is enabled it will become the perferred
           scaling driver for Sandy bridge processors.
 
-	  Note: This driver should be built with the same settings as
-	  the other scaling drivers configured into the system
-	  (module/built-in) in order for the driver to register itself
-	  as the scaling driver on the system.
-
 	  If in doubt, say N.
 
 config X86_PCC_CPUFREQ
-- 
1.7.7.6

