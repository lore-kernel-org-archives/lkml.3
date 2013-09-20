Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3ITJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:57:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42161 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3ITJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:57:21 -0400
Date: Fri, 20 Sep 2013 02:57:01 -0700
From: tip-bot for Vinson Lee <tipbot@zytor.com>
Message-ID: <tip-ce7eebe5c3deef8e19c177c24ee75843256e69ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de, vlee@twitter.com,
        vlee@freedesktop.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, bp@suse.de, vlee@twitter.com,
        vlee@freedesktop.org
In-Reply-To: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
References: <1379546200-17028-1-git-send-email-vlee@freedesktop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib lk: Uninclude linux/
 magic.h in debugfs.c
Git-Commit-ID: ce7eebe5c3deef8e19c177c24ee75843256e69ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 02:57:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce7eebe5c3deef8e19c177c24ee75843256e69ca
Gitweb:     http://git.kernel.org/tip/ce7eebe5c3deef8e19c177c24ee75843256e69ca
Author:     Vinson Lee <vlee@twitter.com>
AuthorDate: Wed, 18 Sep 2013 16:16:40 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Sep 2013 15:08:53 -0300

tools lib lk: Uninclude linux/magic.h in debugfs.c

The compilation only looks for linux/magic.h from the default include
paths, which does not include the source tree. This results in a build
error if linux/magic.h is not available or not installed.

For example, this build error occurs on CentOS 5.

$ make -C tools/lib/lk V=1
[...]
gcc -o debugfs.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6
-D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement
-Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations
-Wmissing-prototypes -Wnested-externs -Wno-system-headers
-Wold-style-definition -Wpacked -Wredundant-decls -Wshadow
-Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum
-Wundef -Wwrite-strings -Wformat  -fPIC  -D_LARGEFILE64_SOURCE
-D_FILE_OFFSET_BITS=64 debugfs.c
debugfs.c:8:25: error: linux/magic.h: No such file or directory

The only symbol from linux/magic.h needed by debugfs.c is DEBUGFS_MAGIC,
and that is already defined in debugfs.h. linux/magic.h isn't providing
any extra symbols and can unincluded. This is similar to the approach by
perf, which has its own magic.h wrapper at
tools/perf/util/include/linux/magic.h

Signed-off-by: Vinson Lee <vlee@twitter.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Vinson Lee <vlee@freedesktop.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1379546200-17028-1-git-send-email-vlee@freedesktop.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index 099e7cd..7c43479 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -5,7 +5,6 @@
 #include <stdbool.h>
 #include <sys/vfs.h>
 #include <sys/mount.h>
-#include <linux/magic.h>
 #include <linux/kernel.h>
 
 #include "debugfs.h"
