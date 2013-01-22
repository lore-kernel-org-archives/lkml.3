Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3AVVCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:02:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46944 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab3AVVCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:02:43 -0500
Date: Tue, 22 Jan 2013 13:01:19 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] arch/x86 cpu hotplug: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130122210119.GA311@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3ac0e64..f5f937a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1697,7 +1697,7 @@ config HOTPLUG_CPU
 config BOOTPARAM_HOTPLUG_CPU0
 	bool "Set default setting of cpu0_hotpluggable"
 	default n
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Set whether default state of cpu0_hotpluggable is on or off.
 
@@ -1726,7 +1726,7 @@ config BOOTPARAM_HOTPLUG_CPU0
 config DEBUG_HOTPLUG_CPU0
 	def_bool n
 	prompt "Debug CPU0 hotplug"
-	depends on HOTPLUG_CPU && EXPERIMENTAL
+	depends on HOTPLUG_CPU
 	---help---
 	  Enabling this option offlines CPU0 (if CPU0 can be offlined) as
 	  soon as possible and boots up userspace with CPU0 offlined. User
-- 
1.7.9.5

-- 
Kees Cook
Chrome OS Security
