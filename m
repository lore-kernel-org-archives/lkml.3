Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbbALFF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:05:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbbALFFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:05:17 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [Patch V2 4/4] xen: check for zero sized area when invalidating memory
Date: Mon, 12 Jan 2015 06:05:10 +0100
Message-Id: <1421039110-11207-5-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421039110-11207-1-git-send-email-jgross@suse.com>
References: <1421039110-11207-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the linear mapped p2m list setting memory
areas to "invalid" had to be delayed. When doing the invalidation
make sure no zero sized areas are processed.

Signed-off-by: Juegren Gross <jgross@suse.com>
---
 arch/x86/xen/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 410210f..865e56c 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -160,6 +160,8 @@ void __init xen_inv_extra_mem(void)
 	int i;
 
 	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
+		if (!xen_extra_mem[i].size)
+			continue;
 		pfn_s = PFN_DOWN(xen_extra_mem[i].start);
 		pfn_e = PFN_UP(xen_extra_mem[i].start + xen_extra_mem[i].size);
 		for (pfn = pfn_s; pfn < pfn_e; pfn++)
-- 
2.1.2

