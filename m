Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaGTADS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 20:03:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49054 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbaGTADQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 20:03:16 -0400
From: Matt Rushton <mvrushton@gmail.com>
X-Google-Original-From: Matt Rushton <mrushton@amazon.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: msw@amazon.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Matt Rushton <mrushton@amazon.com>
Subject: [PATCH v2 1/2] xen/setup: Remove Identity Map Debug Message
Date: Sat, 19 Jul 2014 17:01:34 -0700
Message-Id: <1405814495-10868-1-git-send-email-mrushton@amazon.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a debug message for setting the identity map since it becomes
rather noisy after rework of the identity map code.

Signed-off-by: Matthew Rushton <mrushton@amazon.com>
---
 arch/x86/xen/p2m.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 9bb3d82..3172692 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -841,10 +841,9 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 			pfn = ALIGN(pfn, P2M_PER_PAGE);
 	}
 
-	if (!WARN((pfn - pfn_s) != (pfn_e - pfn_s),
+	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
 		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
-		(pfn_e - pfn_s) - (pfn - pfn_s)))
-		printk(KERN_DEBUG "1-1 mapping on %lx->%lx\n", pfn_s, pfn);
+		(pfn_e - pfn_s) - (pfn - pfn_s));
 
 	return pfn - pfn_s;
 }
-- 
1.7.9.5

