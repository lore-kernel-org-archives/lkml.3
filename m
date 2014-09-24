Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaIXEdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:33:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:59137 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaIXEdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:33:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,586,1406617200"; 
   d="scan'208";a="604434967"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86: Fix section conflict for numachip
Date: Wed, 24 Sep 2014 06:32:19 +0200
Message-Id: <1411533139-25708-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A variable cannot be both __read_mostly and const. This
is a meaningless combination.

Just make it only const.

This fixes the LTO build with numachip enabled.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/apic/apic_numachip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index a5b45df..2f8be54 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@
 
 static int numachip_system __read_mostly;
 
-static const struct apic apic_numachip __read_mostly;
+static const struct apic apic_numachip;
 
 static unsigned int get_apic_id(unsigned long x)
 {
-- 
2.1.0

