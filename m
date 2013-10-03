Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3JCERl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:17:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab3JCERj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:17:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vinson Lee <vlee@twitter.com>, Borislav Petkov <bp@suse.de>,
        Vinson Lee <vlee@freedesktop.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 14/57] tools lib lk: Uninclude linux/magic.h in debugfs.c
Date: Wed,  2 Oct 2013 21:08:40 -0700
Message-Id: <20131003040637.586167776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinson Lee <vlee@twitter.com>

commit ce7eebe5c3deef8e19c177c24ee75843256e69ca upstream.

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
Link: http://lkml.kernel.org/r/1379546200-17028-1-git-send-email-vlee@freedesktop.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/lib/lk/debugfs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -5,7 +5,6 @@
 #include <stdbool.h>
 #include <sys/vfs.h>
 #include <sys/mount.h>
-#include <linux/magic.h>
 #include <linux/kernel.h>
 
 #include "debugfs.h"


