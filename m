Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaC1C4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:56:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:7094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbaC1C4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,747,1389772800"; 
   d="scan'208";a="481861248"
From: Feng Tang <feng.tang@intel.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Andy Lutomirski <luto@amacapital.net>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for X86_64
Date: Fri, 28 Mar 2014 10:55:16 +0800
Message-Id: <1395975316-4795-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many new phone/tablet platforms like Baytrail/Merrifield etc,
the HPET are either defeatured or has some problem to be used
as a reliable timer. As these platforms also have X86_64, we
should not make HPET_TIMER default y for all X86_64.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/Kconfig |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..7f2fb4b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -695,8 +695,7 @@ config X86_CYCLONE_TIMER
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
-	def_bool X86_64
-	prompt "HPET Timer Support" if X86_32
+	prompt "HPET Timer Support"
 	---help---
 	  Use the IA-PC HPET (High Precision Event Timer) to manage
 	  time in preference to the PIT and RTC, if a HPET is
@@ -709,9 +708,9 @@ config HPET_TIMER
 
 	  You can safely choose Y here.  However, HPET will only be
 	  activated if the platform and the BIOS support this feature.
-	  Otherwise the 8254 will be used for timing services.
 
-	  Choose N to continue using the legacy 8254 timer.
+	  Choose N to use the legacy 8254 timer or the latest
+	  lapic_timer+tsc solution.
 
 config HPET_EMULATE_RTC
 	def_bool y
-- 
1.7.0.4

