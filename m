Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaKKIPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:44 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62847 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:41 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 05/21] backports: keep track of original backported source symbols early on
Date: Tue, 11 Nov 2014 00:14:56 -0800
Message-Id: <1415693712-23743-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We'll later want to do some modifications of symbols we backport
when integrating, but before we do any modification on kconfig
files we should keep track of the original source symbols.

This commit introduces no functional changes right now, it will
become more useful after we start adjusting kconfig entries
for integration.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 gentree.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/gentree.py b/gentree.py
index 7a6deef..cb39a3f 100755
--- a/gentree.py
+++ b/gentree.py
@@ -768,6 +768,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # some post-processing is required
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
+    orig_symbols = configtree.symbols()
     logwrite('Modify Kconfig tree ...')
     configtree.prune_sources(ignore=['Kconfig.kernel', 'Kconfig.versions'])
     git_debug_snapshot(args, "prune Kconfig tree")
@@ -829,7 +830,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # rewrite Makefile and source symbols
     regexes = []
-    for some_symbols in [symbols[i:i + 50] for i in range(0, len(symbols), 50)]:
+    for some_symbols in [orig_symbols[i:i + 50] for i in range(0, len(orig_symbols), 50)]:
         r = 'CONFIG_((' + '|'.join([s + '(_MODULE)?' for s in some_symbols]) + ')([^A-Za-z0-9_]|$))'
         regexes.append(re.compile(r, re.MULTILINE))
     for root, dirs, files in os.walk(args.outdir):
-- 
2.1.1

