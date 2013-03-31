Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3CaVns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 17:43:48 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:57081 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3CaVnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 17:43:46 -0400
Date: Sun, 31 Mar 2013 23:43:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, Andreas Schwab <schwab@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH] kbuild: avoid rebuild of file2alias for each build
Message-ID: <20130331214343.GA11285@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When introducing devicetable-offsets generation this
had the side-effect that file2alias (and thus modpost)
were build for each kernel build.

devicetable-offsets were introduced in 6543becf26fff612cdadeed7250ccc8d49f67f27
("mod/file2alias: make modalias generation safe for cross compiling")

"make V=2" said this was due to target not included in targets.
So add devicetable-offsets to targets.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 9415b56..c8e04e9 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -30,10 +30,12 @@ define cmd_offsets
 endef
 
 # We use internal kbuild rules to avoid the "is up to date" message from make
+targets += devicetable-offsets.s
 scripts/mod/devicetable-offsets.s: scripts/mod/devicetable-offsets.c FORCE
 	$(Q)mkdir -p $(dir $@)
 	$(call if_changed_dep,cc_s_c)
 
+targets += $(devicetable-offsets-file)
 $(obj)/$(devicetable-offsets-file): scripts/mod/devicetable-offsets.s
 	$(call cmd,offsets)
 

