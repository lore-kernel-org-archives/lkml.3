Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaLHFcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:32:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaLHFcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:32:24 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: annotate xen_set_identity_and_remap_chunk() with __init
Date: Mon,  8 Dec 2014 06:32:19 +0100
Message-Id: <1418016739-19305-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5b8e7d80542487ff1bf17b4cf2922a01dee13d3a removed the __init
annotation from xen_set_identity_and_remap_chunk(). Add it again.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 12cd199..dfd77de 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -368,7 +368,7 @@ static void __init xen_do_set_identity_and_remap_chunk(
  * pages. In the case of an error the underlying memory is simply released back
  * to Xen and not remapped.
  */
-static unsigned long xen_set_identity_and_remap_chunk(
+static unsigned long __init xen_set_identity_and_remap_chunk(
         const struct e820entry *list, size_t map_size, unsigned long start_pfn,
 	unsigned long end_pfn, unsigned long nr_pages, unsigned long remap_pfn,
 	unsigned long *identity, unsigned long *released)
-- 
2.1.2

