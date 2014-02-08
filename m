Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaBHHyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:54:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:1924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaBHHyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="451781868"
From: Andi Kleen <ak@linux.intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86, sections, numachip: Remove useless __read_mostly
Date: Sat,  8 Feb 2014 08:54:05 +0100
Message-Id: <1391846045-28661-1-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const __read_mostly does not make any sense, because const
data is already read-only. Remove the __read_mostly
for the numachip APIC driver. This avoids a LTO
section conflict compile problem.

Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 3e67f9e..a481bb6 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@
 
 static int numachip_system __read_mostly;
 
-static const struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip;
 
 static unsigned int get_apic_id(unsigned long x)
 {
-- 
1.8.5.2

