Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaG1Rjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:39:33 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:47044 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1Rja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:39:30 -0400
Date: Mon, 28 Jul 2014 19:39:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nick Krause <xerofoify@gmail.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: starvik@axis.com, jesper.nilsson@axis.com, linux-cris-kernel@axis.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] cris: fix headers_install
Message-ID: <20140728173923.GA32593@ravnborg.org>
References: <CAPDOMVjsBPLMM3K6=TtHhPDGRCj865j4e7GF_ubY_jbj+88VWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjsBPLMM3K6=TtHhPDGRCj865j4e7GF_ubY_jbj+88VWQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 87a249d1f35f82e11ffc7c78f0d9ef2399a2ec82 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 13 Jul 2014 23:40:44 +0200
Subject: [PATCH 1/8] cris: fix headers_install

Fix headers_install by adjusting the path to arch files.
And delete unused Kbuild file.
Drop special handling of cris in the headers.sh script as a nice side-effect.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---

I had already cooked this patch up as part of another serie.
Jesper - can you take care this hits mainline this week?

	Sam

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

