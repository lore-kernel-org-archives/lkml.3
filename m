Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3INHB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:01:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54995 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3INHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:01:24 -0400
Date: Sat, 14 Sep 2013 00:01:08 -0700
From: tip-bot for Mathias Nyman <tipbot@zytor.com>
Message-ID: <tip-0f531431d3de88efb4234d6c0ce22089ec035a38@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mika.westerberg@linux.intel.com, mathias.nyman@linux.intel.com,
        rafael.j.wysocki@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathias.nyman@linux.intel.com, mika.westerberg@linux.intel.com,
        tglx@linutronix.de, rafael.j.wysocki@intel.com
In-Reply-To: <1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel/lpss:
  Add pin control support to Intel low power subsystem
Git-Commit-ID: 0f531431d3de88efb4234d6c0ce22089ec035a38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 14 Sep 2013 00:01:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f531431d3de88efb4234d6c0ce22089ec035a38
Gitweb:     http://git.kernel.org/tip/0f531431d3de88efb4234d6c0ce22089ec035a38
Author:     Mathias Nyman <mathias.nyman@linux.intel.com>
AuthorDate: Fri, 13 Sep 2013 17:02:29 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 14 Sep 2013 08:06:28 +0200

x86/intel/lpss: Add pin control support to Intel low power subsystem

x86 chips with LPSS (low power subsystem) such as Lynxpoint and
Baytrail have SoC like peripheral support and controllable pins.

At the moment, Baytrail needs the pinctrl-baytrail driver to let
peripherals control their gpio resources, but more pincontrol
functions such as pin muxing and grouping are possible to add
later.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: http://lkml.kernel.org/r/1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..4d5843d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -482,11 +482,12 @@ config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
 	depends on ACPI
 	select COMMON_CLK
+	select PINCTRL
 	---help---
 	  Select to build support for Intel Low Power Subsystem such as
 	  found on Intel Lynxpoint PCH. Selecting this option enables
-	  things like clock tree (common clock framework) which are needed
-	  by the LPSS peripheral drivers.
+	  things like clock tree (common clock framework) and pincontrol
+	  which are needed by the LPSS peripheral drivers.
 
 config X86_RDC321X
 	bool "RDC R-321x SoC"
