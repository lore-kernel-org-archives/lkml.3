Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaAaVpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:45:06 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:48290 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaVpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:45:03 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jan 2014 16:45:03 EST
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, sasha.levin@oracle.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 2/2] tools: lockdep: add include directory to allow tests to compile
Date: Fri, 31 Jan 2014 13:35:32 -0800
Message-Id: <1391204132-14071-3-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
References: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (ovro.ovro.caltech.edu [0.0.0.0]); Fri, 31 Jan 2014 13:35:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

All of the programs in the tests directory require the
liblockdep/mutex.h header in order to compile. Add the include directory
to the compiler options so that the tests can be built with the provided
Makefile.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 tools/lib/lockdep/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index da8b7aa3d351..e8dd7497f57a 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -112,7 +112,7 @@ export Q VERBOSE
 
 LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include -I./uinclude $(CONFIG_INCLUDES)
+INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
-- 
1.8.3.2

