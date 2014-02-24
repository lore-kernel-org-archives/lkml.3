Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaBXCYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:24:09 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53911 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaBXCYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:24:07 -0500
From: minyard@acm.org
To: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/3] ipmi: Turn off default probing of interfaces
Date: Sun, 23 Feb 2014 20:23:34 -0600
Message-Id: <1393208616-16500-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393208616-16500-1-git-send-email-minyard@acm.org>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
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
 drivers/char/ipmi/Kconfig        | 10 ++++++++++
 drivers/char/ipmi/ipmi_si_intf.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 0baa8fa..8e14360 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -50,6 +50,16 @@ config IPMI_SI
 	 Currently, only KCS and SMIC are supported.  If
 	 you are using IPMI, you should probably say "y" here.
 
+config IPMI_SI_PROBE_DEFAULTS
+       bool 'Probe for all possible IPMI system interfaces by default'
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
index 03f4189..7b420e1 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1230,7 +1230,11 @@ static bool          si_tryplatform = 1;
 #ifdef CONFIG_PCI
 static bool          si_trypci = 1;
 #endif
+#ifdef CONFIG_IPMI_SI_PROBE_DEFAULTS
 static bool          si_trydefaults = 1;
+#else
+static bool          si_trydefaults;
+#endif
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
-- 
1.8.3.1

