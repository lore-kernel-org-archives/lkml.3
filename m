Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3KNQmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:42:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab3KNQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:41:32 -0500
Date: Thu, 14 Nov 2013 17:41:27 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Will Deacon <will.deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH] clocksource: Limit CONFIG_ARM_ARCH_TIMER_EVTSTREAM
 visibility
Message-ID: <20131114174127.7db8c3aa@endymion.delvare>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuration option ARM_ARCH_TIMER_EVTSTREAM makes no sense if
ARM_ARCH_TIMER itself isn't set.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/clocksource/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-3.13-rc0.orig/drivers/clocksource/Kconfig	2013-11-14 15:01:54.892776562 +0100
+++ linux-3.13-rc0/drivers/clocksource/Kconfig	2013-11-14 17:33:18.170646123 +0100
@@ -86,7 +86,8 @@ config ARM_ARCH_TIMER
 
 config ARM_ARCH_TIMER_EVTSTREAM
 	bool "Support for ARM architected timer event stream generation"
-	default y if ARM_ARCH_TIMER
+	depends on ARM_ARCH_TIMER
+	default y
 	help
 	  This option enables support for event stream generation based on
 	  the ARM architected timer. It is used for waking up CPUs executing


-- 
Jean Delvare
Suse L3 Support
