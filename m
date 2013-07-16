Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab3GPSaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:30:06 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:51952 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab3GPSaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:30:02 -0400
From: Jim Baxter <jim_baxter@mentor.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] kbuild: Build samples directory with make modules
Date: Tue, 16 Jul 2013 19:29:50 +0100
Message-Id: <1373999390-14548-1-git-send-email-jim_baxter@mentor.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <Jim Baxter <jim_baxter@mentor.com>
References: <Jim Baxter <jim_baxter@mentor.com>
X-OriginalArrivalTime: 16 Jul 2013 18:30:00.0429 (UTC) FILETIME=[7B15F9D0:01CE8252]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_SAMPLES is enabled with any of the sample
modules enabled, they are only built if the make command
includes uImage and modules (i.e. make uImage modules).

This patches allows the kernel and modules to be built
separately, this is how openembedded and yocto build
the kernel.

Signed-off-by: Jim Baxter <jim_baxter@mentor.com>
---
 Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 29339b4..1acd69f 100644
--- a/Makefile
+++ b/Makefile
@@ -772,9 +772,6 @@ vmlinux: scripts/link-vmlinux.sh $(vmlinux-deps) FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_SAMPLES
-	$(Q)$(MAKE) $(build)=samples
-endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
@@ -943,6 +940,9 @@ all: modules
 
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
+ifdef CONFIG_SAMPLES
+	$(Q)$(MAKE) $(build)=samples
+endif
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-- 
1.7.10.4

