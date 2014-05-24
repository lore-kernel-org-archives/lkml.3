Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaEXMGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:06:35 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:12774 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaEXMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:06:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiALAFKKgFNbtALU/2dsb2JhbABagwerDgQBAQEBAQEFAYM8lE6BBBd0gwIjgRo3iEYB13AXhVWIfR2EKgSPP4o0ixeIEIM6Ow
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/textsearch.c: move EXPORT_SYMBOL after functions
Date: Sat, 24 May 2014 14:06:27 +0200
Message-Id: <1400933187-14900-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable"

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/textsearch.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/textsearch.c b/lib/textsearch.c
index e0cc014..0c7e9ab 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -159,6 +159,7 @@ errout:
 	spin_unlock(&ts_mod_lock);
 	return err;
 }
+EXPORT_SYMBOL(textsearch_register);
 
 /**
  * textsearch_unregister - unregister a textsearch module
@@ -190,6 +191,7 @@ out:
 	spin_unlock(&ts_mod_lock);
 	return err;
 }
+EXPORT_SYMBOL(textsearch_unregister);
 
 struct ts_linear_state
 {
@@ -236,6 +238,7 @@ unsigned int textsearch_find_continuous(struct ts_config *conf,
 
 	return textsearch_find(conf, state);
 }
+EXPORT_SYMBOL(textsearch_find_continuous);
 
 /**
  * textsearch_prepare - Prepare a search
@@ -298,6 +301,7 @@ errout:
 		
 	return ERR_PTR(err);
 }
+EXPORT_SYMBOL(textsearch_prepare);
 
 /**
  * textsearch_destroy - destroy a search configuration
@@ -316,9 +320,4 @@ void textsearch_destroy(struct ts_config *conf)
 
 	kfree(conf);
 }
-
-EXPORT_SYMBOL(textsearch_register);
-EXPORT_SYMBOL(textsearch_unregister);
-EXPORT_SYMBOL(textsearch_prepare);
-EXPORT_SYMBOL(textsearch_find_continuous);
 EXPORT_SYMBOL(textsearch_destroy);
-- 
1.8.4.5

