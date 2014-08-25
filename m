Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaHYIuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:50:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43543 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaHYIuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:50:11 -0400
Message-ID: <53FAF8BF.3010008@plexistor.com>
Date: Mon, 25 Aug 2014 11:50:07 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Stable Tree <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>
Subject: [PATCH] Makefile: One last adjustment to relative paths
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

I have one last problem when compiling under an IDE. This
time it is when I compile linux under another Makefile
with the use of
	make -C linux

The make command is run from /home/boaz/dev/
What the IDE will see is:
make[1]: Entering directory `/home/boaz/dev/linux-open-osd'

	This one is from the external make dev/Makefile

make[1]: Entering directory `.build_um'

       ^ This one is emulated by Linux Makefile
       ...

make[1]: Entering directory `.build_um'

       ^ This one is emulated by Linux Makefile again
error: ../foo/baz.c:XXX
       ...

The IDE will look for ../foo/baz.c at
	/home/boaz/dev/.build_um/../foo/baz.c ==
	/home/boaz/dev/foo/baz.c

This is because make will always print its "Entering directory"
full path or relative to the original make command, this is
make -C rules.

the simple fix is to have "Entering directory" print full path.

[Stable needed for 3.16]
CC: Stable Tree <stable@vger.kernel.org>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6b27741..973c48f 100644
--- a/Makefile
+++ b/Makefile
@@ -178,7 +178,7 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
  quiet_echodir := @echo
 silent_echodir := @:
 sub-make: FORCE
-	$($(quiet)echodir) "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
+	$($(quiet)echodir) "make[1]: Entering directory \`$(CURDIR)/$(KBUILD_OUTPUT)'"
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
-- 
1.9.3

