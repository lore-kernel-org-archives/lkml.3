Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaDNOsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:48:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:64488 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaDNOrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:47:07 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/7] ipmi: Turn off default probing of interfaces
Date: Mon, 14 Apr 2014 09:46:53 -0500
Message-Id: <1397486816-18045-5-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397486816-18045-1-git-send-email-minyard@acm.org>
References: <1397486816-18045-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The default probing can cause problems with some system, slow booting,
extra CPU usages, etc.  Turn it off by default and give a config option
to enable it.

From: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/Kconfig        | 12 ++++++++++++
 drivers/char/ipmi/ipmi_si_intf.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 0baa8fa..db1c9b7 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -50,6 +50,18 @@ config IPMI_SI
 	 Currently, only KCS and SMIC are supported.  If
 	 you are using IPMI, you should probably say "y" here.
 
+config IPMI_SI_PROBE_DEFAULTS
+       bool 'Probe for all possible IPMI system interfaces by default'
+       default n
+       depends on IPMI_SI
+       help
+	 Modern systems will usually expose IPMI interfaces via a discoverable
+	 firmware mechanism such as ACPI or DMI. Older systems do not, and so
+	 the driver is forced to probe hardware manually. This may cause boot
+	 delays. Say "n" here to disable this manual probing. IPMI will then
+	 only be available on older systems if the "ipmi_si_intf.trydefaults=1"
+	 boot argument is passed.
+
 config IPMI_WATCHDOG
        tristate 'IPMI Watchdog Timer'
        help
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 9c40691..25a1436 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1239,7 +1239,7 @@ static bool          si_tryplatform = 1;
 #ifdef CONFIG_PCI
 static bool          si_trypci = 1;
 #endif
-static bool          si_trydefaults = 1;
+static bool          si_trydefaults = IS_ENABLED(CONFIG_IPMI_SI_PROBE_DEFAULTS);
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
-- 
1.8.3.1

