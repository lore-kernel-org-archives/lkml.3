Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHPVOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:14:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaHPVOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:14:53 -0400
Message-ID: <53EFC9CC.3060405@infradead.org>
Date: Sat, 16 Aug 2014 14:14:52 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: [PATCH] scripts/kernel-doc: recognize __meminit attribute
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix scripts/kernel-doc to recognize __meminit in a function prototype
and to stip it, as done with many other attributes.

Fixes this warning:
Warning(..//mm/page_alloc.c:2973): cannot understand function prototype: 'void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) '

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

Added to my patch queue.

Index: lnx-317-rc1/scripts/kernel-doc
===================================================================
--- lnx-317-rc1.orig/scripts/kernel-doc
+++ lnx-317-rc1/scripts/kernel-doc
@@ -2085,6 +2085,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__init +//;
     $prototype =~ s/__init_or_module +//;
+    $prototype =~ s/__meminit +//;
     $prototype =~ s/__must_check +//;
     $prototype =~ s/__weak +//;
     my $define = $prototype =~ s/^#\s*define\s+//; #ak added
