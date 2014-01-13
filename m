Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaAMQZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:25:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaAMQEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 142/208] sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to sh_ksyms_32.c
Date: Mon, 13 Jan 2014 15:59:43 +0000
Message-Id: <1389628849-1614-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

commit ad70b029d2c678386384bd72c7fa2705c449b518 upstream.

Min_low_pfn and max_low_pfn were used in pfn_valid macro if defined
CONFIG_FLATMEM.  When the functions that use the pfn_valid is used in
driver module, max_low_pfn and min_low_pfn is to undefined, and fail to
build.

  ERROR: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!
  ERROR: "max_low_pfn" [drivers/block/aoe/aoe.ko] undefined!
  make[2]: *** [__modpost] Error 1
  make[1]: *** [modules] Error 2

This patch fix this problem.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sh/kernel/sh_ksyms_32.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/sh/kernel/sh_ksyms_32.c b/arch/sh/kernel/sh_ksyms_32.c
index 2a0a596..d77f2f6 100644
--- a/arch/sh/kernel/sh_ksyms_32.c
+++ b/arch/sh/kernel/sh_ksyms_32.c
@@ -20,6 +20,11 @@ EXPORT_SYMBOL(csum_partial_copy_generic);
 EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(__clear_user);
 EXPORT_SYMBOL(empty_zero_page);
+#ifdef CONFIG_FLATMEM
+/* need in pfn_valid macro */
+EXPORT_SYMBOL(min_low_pfn);
+EXPORT_SYMBOL(max_low_pfn);
+#endif
 
 #define DECLARE_EXPORT(name)		\
 	extern void name(void);EXPORT_SYMBOL(name)
-- 
1.8.3.2

