Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaGNPRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:17:52 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48453 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbaGNPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:24 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 10/38] uapi: drop obsolete logic for generated headers
Date: Mon, 14 Jul 2014 17:08:38 +0200
Message-Id: <1405350546-28467-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer call this Makefile with gen set to anything,
so we can simplify logic to find dir for generated files.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>
---
 scripts/Makefile.headersinst | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 3f72031..4718758 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -7,9 +7,6 @@
 #
 # ==========================================================================
 
-# generated header directory
-gen := $(if $(gen),$(gen),$(subst include/,include/generated/,$(obj)))
-
 kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
@@ -33,7 +30,7 @@ check-file    := $(installdir)/.check
 wrapper-files := $(filter $(header-y), $(generic-y))
 
 srcdir        := $(srctree)/$(obj)
-gendir        := $(objtree)/$(gen)
+gendir        := $(objtree)/$(subst include/,include/generated/,$(obj))
 
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
-- 
1.9.3

