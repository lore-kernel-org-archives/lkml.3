Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbaAGAHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:07:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaAFWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.12 042/144] scripts/link-vmlinux.sh: only filter kernel symbols for arm
Date: Mon,  6 Jan 2014 14:36:43 -0800
Message-Id: <20140106223746.539438006@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/link-vmlinux.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


