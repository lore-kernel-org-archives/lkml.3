Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaJQDsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:48:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54358 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaJQDsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:48:30 -0400
From: Martin Kelly <martin@martingkelly.com>
To: david.vrabel@citrix.com, xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, tglx@linutronix.de,
        mingo@redhat.com, Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH] x86/xen: panic on bad Xen-provided memory map
Date: Thu, 16 Oct 2014 20:48:11 -0700
Message-Id: <1413517692-17727-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panic if Xen provides a memory map with 0 entries. Although this is
unlikely, it is better to catch the error at the point of seeing the map
than later on as a symptom of some other crash.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 arch/x86/xen/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index af72161..29834b3 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -595,6 +595,7 @@ char * __init xen_memory_setup(void)
 		rc = 0;
 	}
 	BUG_ON(rc);
+	BUG_ON(memmap.nr_entries == 0);
 
 	/*
 	 * Xen won't allow a 1:1 mapping to be created to UNUSABLE
-- 
2.1.1

