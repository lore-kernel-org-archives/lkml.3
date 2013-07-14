Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3GNKiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 06:38:09 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55211 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab3GNKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 06:38:08 -0400
Message-ID: <1373798285.1370.2.camel@x61.thuisdomein>
Subject: [PATCH] ARM: keystone: drop "select HAVE_SCHED_CLOCK"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Jul 2013 12:38:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2013 10:38:06.0661 (UTC) FILETIME=[39F05750:01CE807E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol HAVE_SCHED_CLOCK got removed in v3.4,
with commit 6905a65879b5 ("ARM: Make the sched_clock
framework mandatory"). But a select statement for it popped up again
through commit 828989ad87af ("ARM: keystone: Add minimal TI Keystone
platform support"). Drop that statement, as it is useless.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not tested.

 arch/arm/mach-keystone/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
index 51a50e9..366d1a3 100644
--- a/arch/arm/mach-keystone/Kconfig
+++ b/arch/arm/mach-keystone/Kconfig
@@ -7,7 +7,6 @@ config ARCH_KEYSTONE
 	select HAVE_SMP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
-	select HAVE_SCHED_CLOCK
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_ERRATA_798181 if SMP
 	help
-- 
1.8.1.4

