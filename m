Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3IZO2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:28:40 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59223 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3IZO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:28:38 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] tools/perf: remove non-existent entries in MANIFEST
Date: Thu, 26 Sep 2013 19:51:44 +0530
Message-Id: <1380205304-32224-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.299.gb3e7d24.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MANIFEST file is used in the following Makefile targets:

  $ make tar{,gz,bz2,xz}-src-pkg

to generate an archive that can be used outside the kernel tree. It
contains entries that are used for pathspec filtering 'git archive',
which ultimately generates the archive. Remove the stale
entries (non-existent paths) by running:

  $ while read l; do file $l; done <tools/perf/MANIFEST | grep ERROR

in the toplevel kernel tree.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Thanks to David for pointing out that the MANIFEST is used by
 scripts/package. This patch safely removes the stale entries.

 tools/perf/MANIFEST | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 025de79..9c85dee 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -2,7 +2,6 @@ tools/perf
 tools/scripts
 tools/lib/traceevent
 tools/lib/lk
-include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
 include/linux/list.h
@@ -10,14 +9,7 @@ include/linux/hash.h
 include/linux/stringify.h
 lib/rbtree.c
 include/linux/swab.h
-arch/*/include/asm/unistd*.h
-arch/*/include/asm/perf_regs.h
-arch/*/include/uapi/asm/unistd*.h
-arch/*/include/uapi/asm/perf_regs.h
-arch/*/lib/memcpy*.S
-arch/*/lib/memset*.S
 include/linux/poison.h
-include/linux/magic.h
 include/linux/hw_breakpoint.h
 include/linux/rbtree_augmented.h
 include/uapi/linux/perf_event.h
-- 
1.8.4.299.gb3e7d24.dirty

