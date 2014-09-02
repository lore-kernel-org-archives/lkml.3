Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaIBOjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:39:11 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:54613 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaIBOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:39:09 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
        Magnus Damm <damm@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Mark Salter <msalter@redhat.com>, Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Robert Graffham <psquid@psquid.net>, Paul Bolle <pebolle@tiscali.nl>,
        linux-sh@vger.kernel.org (open list:SUPERH),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] sh: Fix build error caused by missing dependencies
Date: Tue,  2 Sep 2014 10:39:04 -0400
Message-Id: <1409668745-31693-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a sh4-randconfig build failure which has the following splat:

arch/sh/mm/cache-sh4.c:99:17: error: 'cached_to_uncached' undeclared (first use in this function)
arch/sh/mm/cache-sh4.c:192:2: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]

These errors are caused by missing dependencies on UNCACHED_MAPPING and MMU.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/sh/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 244fb4c..619d5eb 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -194,6 +194,8 @@ config CPU_SH4
 	select SH_INTC
 	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
+	select UNCACHED_MAPPING
+	select MMU
 
 config CPU_SH4A
 	bool
-- 
2.1.0

