Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3KMLRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:17:34 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43528 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab3KMLR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:17:28 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/2] scripts/link-vmlinux.sh: only filter kernel symbols for arm
Date: Wed, 13 Nov 2013 19:15:51 +0800
Message-Id: <1384341351-4110-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
References: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually CONFIG_PAGE_OFFSET isn't same with PAGE_OFFSET, so
it isn't easy to figue out PAGE_OFFSET defined in header
file from scripts.

Because CONFIG_PAGE_OFFSET may not be defined in some ARCHs(
64bit ARCH), or defined as bogus value in !MMU case, so
this patch only applys the filter on ARM when CONFIG_PAGE_OFFSET
is defined as the original problem is only on ARM.

Cc: <stable@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Singed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 scripts/link-vmlinux.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 32b10f5..2dcb377 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -82,7 +82,9 @@ kallsyms()
 		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
-	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	if [ -n "${CONFIG_ARM}" ] && [ -n "${CONFIG_PAGE_OFFSET}" ]; then
+		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	fi
 
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
-- 
1.7.9.5

