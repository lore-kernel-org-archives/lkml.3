Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3CULFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:05:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3CULFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:05:39 -0400
Date: Thu, 21 Mar 2013 04:03:32 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-b28b130719af6e7f56e0bbdac38ba703a36ba5d5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, bp@suse.de, jolsa@redhat.com
In-Reply-To: <1362338733-8718-1-git-send-email-bp@alien8.de>
References: <1362338733-8718-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib lk: Fix _FORTIFY_SOURCE builds
Git-Commit-ID: b28b130719af6e7f56e0bbdac38ba703a36ba5d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:03:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b28b130719af6e7f56e0bbdac38ba703a36ba5d5
Gitweb:     http://git.kernel.org/tip/b28b130719af6e7f56e0bbdac38ba703a36ba5d5
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 3 Mar 2013 20:25:33 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:01 -0300

tools lib lk: Fix _FORTIFY_SOURCE builds

Jiri Olsa triggers the following build error:

    SUBDIR ../lib/lk/
    CC debugfs.o
In file included from /usr/include/errno.h:29:0,
                 from debugfs.c:1:
/usr/include/features.h:314:4: error: #warning _FORTIFY_SOURCE requires compiling with optimization (-O) [-Werror=cpp]

This is because enabling buffer overflow checks through _FORTIFY_SOURCE
require compiler optimizations to be enabled too. However, those are
not. Enable them by simply copying the perf optimization level. It can
be expanded later if we want to support debug builds, etc.

Signed-off-by: Borislav Petkov <bp@suse.de>
Reported-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1362338733-8718-1-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 8cf576f..926cbf3 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -10,7 +10,7 @@ LIB_OBJS += $(OUTPUT)debugfs.o
 
 LIBFILE = liblk.a
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
