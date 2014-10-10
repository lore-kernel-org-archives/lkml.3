Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaJJUeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:34:14 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48126 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJJUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:34:13 -0400
X-Originating-IP: 75.92.167.159
Date: Fri, 10 Oct 2014 13:34:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL 3.18] tinification fixup for 3.18: fadvise without
 CONFIG_MMU
Message-ID: <20141010203359.GA29031@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d3ac21cacc24790eb45d735769f35753f5b56ceb:

  mm: Support compiling out madvise and fadvise (2014-08-17 19:44:24 -0500)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux.git tags/tiny/no-advice-fixup-3.18

for you to fetch changes up to 887e7019e3b8f00c7901c0bc66fb689ced69f7b4:

  mm: Support fadvise without CONFIG_MMU (2014-10-10 13:12:28 -0700)

----------------------------------------------------------------
Fixup for 3.18: use PATCHv2 of "mm: Support compiling out madvise and fadvise"

----------------------------------------------------------------
Josh "Paper Bag" Triplett (1):
      mm: Support fadvise without CONFIG_MMU

 mm/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/Makefile b/mm/Makefile
index fe7a053..2ad574d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -28,8 +28,9 @@ else
 	obj-y		+= bootmem.o
 endif
 
+obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o
 ifdef CONFIG_MMU
-	obj-$(CONFIG_ADVISE_SYSCALLS)	+= fadvise.o madvise.o
+	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
 
