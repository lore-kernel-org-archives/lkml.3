Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbbA1Goc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:44:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbbA1Gob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:31 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/5] xen: add some __init and static annotations in arch/x86/xen/setup.c
Date: Wed, 28 Jan 2015 07:44:23 +0100
Message-Id: <1422427465-25239-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more functions in arch/x86/xen/setup.c can be made "__init".
xen_ignore_unusable() can be made "static".

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/setup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 4dcc608..55f388e 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -535,8 +535,8 @@ static unsigned long __init xen_get_max_pages(void)
 	return min(max_pages, MAX_DOMAIN_PAGES);
 }
 
-static void xen_align_and_add_e820_region(phys_addr_t start, phys_addr_t size,
-					  int type)
+static void __init xen_align_and_add_e820_region(phys_addr_t start,
+						 phys_addr_t size, int type)
 {
 	phys_addr_t end = start + size;
 
@@ -549,7 +549,7 @@ static void xen_align_and_add_e820_region(phys_addr_t start, phys_addr_t size,
 	e820_add_region(start, end - start, type);
 }
 
-void xen_ignore_unusable(struct e820entry *list, size_t map_size)
+static void __init xen_ignore_unusable(struct e820entry *list, size_t map_size)
 {
 	struct e820entry *entry;
 	unsigned int i;
-- 
2.1.2

