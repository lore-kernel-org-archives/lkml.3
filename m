Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaDBCps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:45:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20651 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbaDBCpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:45:47 -0400
Subject: [PATCH] tile: Fix vDSO compilation issue with allyesconfig
From: Kerry Sheh <ksheh@tilera.com>
Reply-To: <ksheh@tilera.com>
To: Chris Metcalf <cmetcalf@tilera.com>, <linux-kernel@vger.kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Tony Lu <zlu@tilera.com>,
        <kbuild-all@01.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Tilera Corp.
Date: Wed, 2 Apr 2014 10:45:35 +0800
Message-ID: <1396406735.3515.11.camel@debian>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make allyesconfig give the following build error on tile:
 tilegx-linux-gcc: error: arch/tile/kernel/vdso/vgettimeofday32.o: No such file or directory
 tilegx-linux-objcopy: 'arch/tile/kernel/vdso/vdso32.so.dbg': No such file or directory

In case with CONFIG_MODVERSIONS, cmd_cc_o_c generate .tmp_<file>.o from
<file>.c only. Fix it by execute rule_cc_o_c instead.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kerry Sheh <ksheh@tilera.com>
---
 arch/tile/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/vdso/Makefile b/arch/tile/kernel/vdso/Makefile
index e2b7a2f..a025f63 100644
--- a/arch/tile/kernel/vdso/Makefile
+++ b/arch/tile/kernel/vdso/Makefile
@@ -104,7 +104,7 @@ $(obj-vdso32:%=%): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(obj-vdso32:%=%): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
 $(obj)/vgettimeofday32.o: $(obj)/vgettimeofday.c
-	$(call if_changed,cc_o_c)
+	$(call if_changed_rule,cc_o_c)
 
 $(obj)/vrt_sigreturn32.o: $(obj)/vrt_sigreturn.S
 	$(call if_changed,as_o_S)
-- 
1.8.3.1

-- 
Kerry Sheh <ksheh@tilera.com>
Tilera Corp.
Rm B308, No 8 Northeast Wangxi Rd, Haidian, Beijing Zhongguancun Software Park
Tel:  +86-10-82825915-633
Cell: +86-10-152-1018-2083

