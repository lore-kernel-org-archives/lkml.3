Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaCOJmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 05:42:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbaCOJmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 05:42:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: xen-devel@lists.xenproject.org
Subject: [PATCH] Xen: include asm/page.h in xen-ops.h
Date: Sat, 15 Mar 2014 10:42:15 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403151042.15932.arnd@arndb.de>
X-Provags-ID: V02:K0:waxqAu9fdim9qpI+NkwiEgcahY/5terzMNChyBO58Bw
 2EW1J1SHTquDc0e8Q0NSJhycXIa7GMr8ZDyqFUlUf5GA/bGB8p
 Azj9goDITq5RQg6n4wj2A/5ICH9ebeIMWumLrPJfESbBV0EZH2
 28P5E1eIJ+ffYSyfFVud8IipTRJWrNKRqVtqmVBFr9RHy2bSrZ
 xBhBLNdbFJ/avwBBNffuJFlhVQNP9SHh2pigH7sGbf/d79n7sw
 CYOpk5vdAiLlxG84ueIie+yAenQmmTI6CAslVkS7sxJQZWymAn
 ONm3zZXTy2K00IVgF1zX6LKZHKYaBPKYSRswq/3DsebSF8FgUu
 BPmoZ9a9tYoWoi0poZhyY1ozQtXTcdOwQV77V9ivl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The declaration of xen_remap_domain_mfn_range relies on the
pgprot_t typedef to be visible. In some configurations, that
may not already have been seen, and I have encountered a
bug during randconfig testing on ARM.

Adding an explicit #include for asm/page.h fixes the problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 6d8c042..b8ad234 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -3,6 +3,7 @@
 
 #include <linux/percpu.h>
 #include <asm/xen/interface.h>
+#include <asm/page.h>
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 
