Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3C1VqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:46:19 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:64844 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab3C1VqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:46:18 -0400
Message-ID: <1364507176.1345.45.camel@x61.thuisdomein>
Subject: [PATCH] ARM: remove last use of CONFIG_CPU_ARM710
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 22:46:16 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2013 21:46:16.0332 (UTC) FILETIME=[ACA1ACC0:01CE2BFD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for ARM710 CPUs was removed in v3.5. Now remove the last code
depending on its Kconfig macro.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Note that cpu_arm7_data_abort was also removed.

 arch/arm/include/asm/glue-df.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/include/asm/glue-df.h b/arch/arm/include/asm/glue-df.h
index 8cacbcd..75e6908 100644
--- a/arch/arm/include/asm/glue-df.h
+++ b/arch/arm/include/asm/glue-df.h
@@ -31,14 +31,6 @@
 #undef CPU_DABORT_HANDLER
 #undef MULTI_DABORT
 
-#if defined(CONFIG_CPU_ARM710)
-# ifdef CPU_DABORT_HANDLER
-#  define MULTI_DABORT 1
-# else
-#  define CPU_DABORT_HANDLER cpu_arm7_data_abort
-# endif
-#endif
-
 #ifdef CONFIG_CPU_ABRT_LV4T
 # ifdef CPU_DABORT_HANDLER
 #  define MULTI_DABORT 1
-- 
1.7.11.7

