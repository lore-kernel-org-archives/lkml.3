Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaL3Fpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:45:45 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46810 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaL3Fpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:45:43 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        Stephen Hemminger <shemming@brocade.com>,
        Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] assoc_array: Include rcupdate.h for call_rcu() definition
Date: Tue, 30 Dec 2014 00:46:21 -0500
Message-Id: <1419918382-4758-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include rcupdate.h header to provide call_rcu() definition. This was implicitly
being provided by slab.h file which include srcu.h somewhere in its include
hierarchy which in-turn included rcupdate.h. 

Lately, tinification effort added support to remove srcu entirely because of
which we are encountering build errors like

lib/assoc_array.c: In function 'assoc_array_apply_edit':
lib/assoc_array.c:1426:2: error: implicit declaration of function 'call_rcu' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Fix these by including rcupdate.h explicitly.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Scott Wood <scottwood@freescale.com>
---
 lib/assoc_array.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 2404d03..03dd576 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -11,6 +11,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 //#define DEBUG
+#include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/assoc_array_priv.h>
-- 
1.9.1

