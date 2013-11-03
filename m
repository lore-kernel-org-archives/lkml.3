Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3KCLJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 06:09:35 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44236 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KCLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 06:09:34 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Ryan Barnett <rjbarnet@rockwellcollins.com>
Subject: [PATCH] Makefile: fix out-of-tree builds for multiple targets with 'all'
Date: Sun,  3 Nov 2013 12:09:24 +0100
Message-Id: <1383476964-25815-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

For out-of-tree builds, this use-case fails to build:
    $ make clean all

This is because 'all' is filtered-out in the Makefile wrapper, since
the wrapper itself has a 'all' target.

The 'all' target is just the usual naming for the default target in a
Makefile. In fact, the first target is the default one, so we can name
it whatever we want.

Rename the Makefile wrapper 'all' target to avoid name-clashing.

Reported-by: Ryan Barnett <rjbarnet@rockwellcollins.com>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Ryan Barnett <rjbarnet@rockwellcollins.com>

---
Note: this still does not allow 'make menuconfig all', but that is not
even working for in-tree builds either.
---
 scripts/mkmakefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 0cc0442..28583bc 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -42,18 +42,18 @@ MAKEARGS += O=\$(if \$(patsubst /%,,\$(makedir)),\$(CURDIR)/)\$(patsubst %/,%,\$
 
 MAKEFLAGS += --no-print-directory
 
-.PHONY: all \$(MAKECMDGOALS)
+.PHONY: _all \$(MAKECMDGOALS)
 
-all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
+all	:= \$(filter-out Makefile,\$(MAKECMDGOALS))
 
-all:
+_all:
 	\$(Q)\$(MAKE) \$(MAKEARGS) \$(all)
 
 Makefile:;
 
-\$(all): all
+\$(all): _all
 	@:
 
-%/: all
+%/: _all
 	@:
 EOF
-- 
1.8.1.2

