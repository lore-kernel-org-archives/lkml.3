Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaLYFcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 00:32:31 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:55610 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaLYFbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 00:31:53 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Michal Marek <mmarek@suse.cz>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Jonathan Corbet <corbet@lwn.net>, Robert Richter <rrichter@cavium.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] kbuild: allow cc-ifversion to have the argument for false condition
Date: Thu, 25 Dec 2014 14:31:27 +0900
Message-Id: <1419485488-22336-6-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro "try-run" can have an argument for each of true and false
cases.  Having an argument for the false case of cc-ifversion (and
ld-ifversion) would be useful too.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Documentation/kbuild/makefiles.txt | 5 +++--
 scripts/Kbuild.include             | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 7b3487a..a64f3c6 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -531,8 +531,9 @@ more details, with real examples.
 	than or equal to gcc 3.0.
 
     cc-ifversion
-	cc-ifversion tests the version of $(CC) and equals last argument if
-	version expression is true.
+	cc-ifversion tests the version of $(CC) and equals the fourth parameter
+	if version expression is true, or the fifth (if given) if the version
+	expression is false.
 
 	Example:
 		#fs/reiserfs/Makefile
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 69c9f57..6182fa6 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -144,7 +144,7 @@ cc-fullversion = $(shell $(KBUILD_SHELL) \
 
 # cc-ifversion
 # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
-cc-ifversion = $(shell [ $(cc-version) $(1) $(2) ] && echo $(3))
+cc-ifversion = $(shell [ $(cc-version) $(1) $(2) ] && echo $(3) || echo $(4))
 
 # cc-ldoption
 # Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
@@ -167,7 +167,7 @@ ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
 
 # ld-ifversion
 # Usage:  $(call ld-ifversion, -ge, 22252, y)
-ld-ifversion = $(shell [ $(ld-version) $(1) $(2) ] && echo $(3))
+ld-ifversion = $(shell [ $(ld-version) $(1) $(2) ] && echo $(3) || echo $(4))
 
 ######
 
-- 
1.9.1

