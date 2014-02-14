Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBNVYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:24:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:47111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaBNVWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="455752589"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/19] lto: Don't inline __const_udelay
Date: Fri, 14 Feb 2014 22:21:43 +0100
Message-Id: <1392412903-25733-20-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

__const_udelay is marked inline, and LTO will happily inline it everywhere
Dropping the inline saves ~44k text in a non LTO build.

13999560        1740864 1499136 17239560        1070e08 vmlinux-with-udelay-inline
13954764        1736768 1499136 17190668        1064f0c vmlinux-wo-udelay-inline

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 39d6a3d..540a320 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -112,7 +112,7 @@ void __delay(unsigned long loops)
 }
 EXPORT_SYMBOL(__delay);
 
-inline void __const_udelay(unsigned long xloops)
+void __const_udelay(unsigned long xloops)
 {
 	int d0;
 
-- 
1.8.5.2

