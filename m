Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3KRNts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:49:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab3KRNtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:49:42 -0500
Date: Mon, 18 Nov 2013 08:48:07 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arm/xen: Export phys_to_mach to fix Xen module link errors
Message-ID: <20131118134806.GA1908@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various xen drivers fail to link when built as modules with the following
error:

ERROR: "phys_to_mach" [drivers/xen/xen-gntalloc.ko] undefined!
ERROR: "phys_to_mach" [drivers/net/xen-netfront.ko] undefined!
ERROR: "phys_to_mach" [drivers/net/xen-netback/xen-netback.ko] undefined!
ERROR: "phys_to_mach" [drivers/block/xen-blkfront.ko] undefined!

The mfn_to_pfn and pfn_to_mfn functions get inlined in these modules and
those functions require phys_to_mach.  Export the symbol to fix the link
errors.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/arm/xen/p2m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index 23732cd..0f842e8 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -27,6 +27,7 @@ struct xen_p2m_entry {
 
 rwlock_t p2m_lock;
 struct rb_root phys_to_mach = RB_ROOT;
+EXPORT_SYMBOL_GPL(phys_to_mach);
 static struct rb_root mach_to_phys = RB_ROOT;
 
 static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
-- 
1.8.3.1

