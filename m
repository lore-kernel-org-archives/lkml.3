Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaAMO1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaAMOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 30/96] scripts/link-vmlinux.sh: only filter kernel symbols for arm
Date: Mon, 13 Jan 2014 14:23:53 +0000
Message-Id: <1389623099-18783-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

commit 7122c3e9154b5d9a7422f68f02d8acf050fad2b0 upstream.

Actually CONFIG_PAGE_OFFSET isn't same with PAGE_OFFSET, so
it isn't easy to figue out PAGE_OFFSET defined in header
file from scripts.

Because CONFIG_PAGE_OFFSET may not be defined in some ARCHs(
64bit ARCH), or defined as bogus value in !MMU case, so
this patch only applys the filter on ARM when CONFIG_PAGE_OFFSET
is defined as the original problem is only on ARM.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Fixes: f6537f2f0eba4eba3354e48dbe3047db6d8b6254
Singed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/link-vmlinux.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 7a9f7f9..304c9f1 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -78,7 +78,9 @@ kallsyms()
 		kallsymopt=--all-symbols
 	fi
 
-	kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	if [ -n "${CONFIG_ARM}" ] && [ -n "${CONFIG_PAGE_OFFSET}" ]; then
+		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
+	fi
 
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
-- 
1.8.3.2

