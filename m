Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaJIVM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:12:56 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43029 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIVMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:12:49 -0400
From: Omar Sandoval <osandov@osandov.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] textsearch: clarify how to clean up in doc
Date: Thu,  9 Oct 2014 14:11:57 -0700
Message-Id: <1412889117-26084-1-git-send-email-osandov@osandov.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

textsearch_put() doesn't exist; this comment appears to be referring to
textsearch_destroy().

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
This patch applies to 3.17. There was a patch submitted previously which got
rid of this documentation (https://lkml.org/lkml/2014/9/6/128), but this is a
little more clear, as clean up is still required.

 lib/textsearch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/textsearch.c b/lib/textsearch.c
index 0c7e9ab..7f52c8f 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -251,7 +251,7 @@ EXPORT_SYMBOL(textsearch_find_continuous);
  * Looks up the search algorithm module and creates a new textsearch
  * configuration for the specified pattern. Upon completion all
  * necessary refcnts are held and the configuration must be put back
- * using textsearch_put() after usage.
+ * using textsearch_destroy() after usage.
  *
  * Note: The format of the pattern may not be compatible between
  *       the various search algorithms.
-- 
2.1.2

