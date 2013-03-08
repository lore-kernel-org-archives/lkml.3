Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3CHK37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:29:59 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61280 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330Ab3CHK36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:29:58 -0500
Message-ID: <1362738596.5994.48.camel@x61.thuisdomein>
Subject: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 11:29:56 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 10:29:56.0991 (UTC) FILETIME=[E132A0F0:01CE1BE7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When support was added for Nokia N9 (RM-696), with commit
63fc5f3bb3d0ca9ab4767a801b518aa6335f87ad ("ARM: OMAP: add minimal
support for Nokia RM-696"), a select statement for MACH_NOKIA_RM696 was
added to the tree. But there's no Kconfig symbol with that name. That
symbol would be superfluous, since support for that machine piggybacks
on MACH_NOKIA_RM680. So drop that select.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "git grep".

1) Some searching on the web didn't return a "config MACH_NOKIA_RM696".
So apparently there's not even a development tree that uses this symbol.

 arch/arm/mach-omap2/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 49ac3df..5cafa77 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -296,7 +296,6 @@ config MACH_NOKIA_RM680
 	bool "Nokia N950 (RM-680) / N9 (RM-696) phones"
 	depends on ARCH_OMAP3
 	default y
-	select MACH_NOKIA_RM696
 	select OMAP_PACKAGE_CBB
 
 config MACH_NOKIA_RX51
-- 
1.7.11.7

