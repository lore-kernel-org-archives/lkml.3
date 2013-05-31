Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3EaKOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:14:32 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57490 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3EaKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:14:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,778,1363132800"; 
   d="scan'208";a="5197989"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
CC: Ian Campbell <ian.campbell@citrix.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: make sure we clean up DTB temporary files
Date: Fri, 31 May 2013 11:14:20 +0100
Message-ID: <1369995261-20735-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various temporary files used when building DTB files were not suffixed with
.tmp and therefore were not cleaned up by "make clean".

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 scripts/Makefile.lib |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 51bb3de..d7ec7cf 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -149,7 +149,7 @@ cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 
 ld_flags       = $(LDFLAGS) $(ldflags-y)
 
-dtc_cpp_flags  = -Wp,-MD,$(depfile).pre -nostdinc                        \
+dtc_cpp_flags  = -Wp,-MD,$(depfile).pre.tmp -nostdinc                    \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
 		 -I$(srctree)/arch/$(SRCARCH)/boot/dts/include           \
 		 -undef -D__DTS__
@@ -265,13 +265,13 @@ quiet_cmd_dtc = DTC     $@
 cmd_dtc = $(CPP) $(dtc_cpp_flags) -x assembler-with-cpp -o $(dtc-tmp) $< ; \
 	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 \
 		-i $(srctree)/arch/$(SRCARCH)/boot/dts $(DTC_FLAGS) \
-		-d $(depfile).dtc $(dtc-tmp) ; \
-	cat $(depfile).pre $(depfile).dtc > $(depfile)
+		-d $(depfile).dtc.tmp $(dtc-tmp) ; \
+	cat $(depfile).pre.tmp $(depfile).dtc.tmp > $(depfile)
 
 $(obj)/%.dtb: $(src)/%.dts FORCE
 	$(call if_changed_dep,dtc)
 
-dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
+dtc-tmp = $(subst $(comma),_,$(dot-target).dts.tmp)
 
 # Bzip2
 # ---------------------------------------------------------------------------
-- 
1.7.10.4

