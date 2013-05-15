Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3EOJVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:21:12 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59671 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab3EOJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:21:03 -0400
Message-ID: <1368609661.1350.185.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove dependency on MV64360
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 11:21:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2013 09:21:01.0716 (UTC) FILETIME=[8478BD40:01CE514D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry that allows to "Distribute interrupts on all CPUs by
default" has a (negative) dependency on MV64360. But that Kconfig symbol
was removed in v2.6.27, which means that this dependency has evaluated
to true ever since. It can be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by grepping the tree.

 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c33e3ad..9a822d9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -404,7 +404,7 @@ config FA_DUMP
 
 config IRQ_ALL_CPUS
 	bool "Distribute interrupts on all CPUs by default"
-	depends on SMP && !MV64360
+	depends on SMP
 	help
 	  This option gives the kernel permission to distribute IRQs across
 	  multiple CPUs.  Saying N here will route all IRQs to the first
-- 
1.7.11.7

