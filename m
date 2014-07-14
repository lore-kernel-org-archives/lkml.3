Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaGNPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:09:27 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48379 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGNPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:18 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 01/38] cris: fix headers_install
Date: Mon, 14 Jul 2014 17:08:29 +0200
Message-Id: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20140714150609.GA28358@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix headers_install by adjusting the path to arch files.
And delete unused Kbuild file.
Drop special handling of cris in the headers.sh script as a nice side-effect.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/cris/include/asm/Kbuild      | 5 -----
 arch/cris/include/uapi/asm/Kbuild | 4 ++--
 scripts/headers.sh                | 2 --
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index afff510..35574f5 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -1,8 +1,3 @@
-
-header-y += arch-v10/
-header-y += arch-v32/
-
-
 generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index 7d47b36..01f66b8 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -1,8 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
-header-y += arch-v10/
-header-y += arch-v32/
+header-y += ../arch-v10/arch/
+header-y += ../arch-v32/arch/
 header-y += auxvec.h
 header-y += bitsperlong.h
 header-y += byteorder.h
diff --git a/scripts/headers.sh b/scripts/headers.sh
index 95ece06..d4dc4de 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -19,8 +19,6 @@ for arch in ${archs}; do
 	case ${arch} in
 	um)        # no userspace export
 		;;
-	cris)      # headers export are known broken
-		;;
 	*)
 		if [ -d ${srctree}/arch/${arch} ]; then
 			do_command $1 ${arch}
-- 
1.9.3

