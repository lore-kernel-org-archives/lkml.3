Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaKKITg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:19:36 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50040 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:50 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 07/21] backports: add prefix for integration on dependencies
Date: Tue, 11 Nov 2014 00:14:58 -0800
Message-Id: <1415693712-23743-8-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

When integrating we need the BACKPORT prefix added to
dependency symbols.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/gentree.py b/gentree.py
index 40b0a55..dd7af84 100755
--- a/gentree.py
+++ b/gentree.py
@@ -921,7 +921,10 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
                     new.append('BACKPORT_DISABLED_KCONFIG_OPTION')
             else:
                     new.append('!BACKPORT_KERNEL_%s' % dep.replace('.', '_'))
-        deplist[sym] = new
+        if bpid.integrate:
+            deplist[sym] = ["BACKPORT_" + x for x in new]
+        else:
+            deplist[sym] = new
     configtree.add_dependencies(deplist)
     git_debug_snapshot(args, "add kernel version dependencies")
 
-- 
2.1.1

