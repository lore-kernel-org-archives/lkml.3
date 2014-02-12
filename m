Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBLIOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50378 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbaBLIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Paul Mundt" <lethal@linux-sh.org>,
        "Nobuhiro Iwamatsu" <nobuhiro.iwamatsu.yj@renesas.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.509793696@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 30/79] sh: always link in helper functions extracted
 from libgcc
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 84ed8a99058e61567f495cc43118344261641c5f upstream.

E.g. landisk_defconfig, which has CONFIG_NTFS_FS=m:

  ERROR: "__ashrdi3" [fs/ntfs/ntfs.ko] undefined!

For "lib-y", if no symbols in a compilation unit are referenced by other
units, the compilation unit will not be included in vmlinux.  This
breaks modules that do reference those symbols.

Use "obj-y" instead to fix this.

http://kisskb.ellerman.id.au/kisskb/buildresult/8838077/

This doesn't fix all cases. There are others, e.g. udivsi3.
This is also not limited to sh, many architectures handle this in the
same way.

A simple solution is to unconditionally include all helper functions.
A more complex solution is to make the choice of "lib-y" or "obj-y" depend
on CONFIG_MODULES:

  obj-$(CONFIG_MODULES) += ...
  lib-y($CONFIG_MODULES) += ...

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sh/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index 7b95f29..3baff31 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -6,7 +6,7 @@ lib-y  = delay.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
 # Extracted from libgcc
-lib-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
+obj-y += movmem.o ashldi3.o ashrdi3.o lshrdi3.o \
 	 ashlsi3.o ashrsi3.o ashiftrt.o lshrsi3.o \
 	 udiv_qrnnd.o
 

