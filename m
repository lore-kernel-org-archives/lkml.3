Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaENIYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:24:32 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50368 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaENIY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:24:27 -0400
Message-ID: <1400055865.31197.4.camel@x220>
Subject: [PATCH] [RESEND] ARM: remove last use of CONFIG_CPU_ARM710
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 10:24:25 +0200
In-Reply-To: <1364507176.1345.45.camel@x61.thuisdomein>
References: <1364507176.1345.45.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 08:24:26.0001 (UTC) FILETIME=[EAD4C010:01CF6F4D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for ARM710 CPUs was removed in v3.5. Now remove the last code
depending on its Kconfig macro.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
First submitted in March 2103. Still untested. Please note that
cpu_arm7_data_abort was also removed in v3.5.

 arch/arm/include/asm/glue-df.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/include/asm/glue-df.h b/arch/arm/include/asm/glue-df.h
index 6b70f1b46a6e..04e18b656659 100644
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
 #ifdef CONFIG_CPU_ABRT_EV4
 # ifdef CPU_DABORT_HANDLER
 #  define MULTI_DABORT 1
-- 
1.9.0

