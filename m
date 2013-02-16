Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3BPAfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:35:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33528 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3BPAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:35:30 -0500
Date: Fri, 15 Feb 2013 16:35:23 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH]: PVH linux: don't print warning in case of failed mapping
Message-ID: <20130215163523.28d00600@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the printing of warning in case of failed mappings. Sometimes
they are expected as in case of Qemu mapping pages during HVM guest
creation.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>

---
 arch/x86/xen/mmu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index fbf6a63..afa6af6 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2499,9 +2499,6 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 	set_xen_guest_handle(xatpr.gpfns, &gpfn);
 
 	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatpr);
-	if (rc)
-		pr_warn("d0: Failed to map pfn to mfn rc:%d pfn:%lx mfn:%lx\n",
-			rc, lpfn, fgmfn);
 	return rc;
 }
 
-- 
1.7.2.3

