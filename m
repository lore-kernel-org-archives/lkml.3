Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaLaBWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:22:22 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39033 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaLaBWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:20 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kbuild@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] lib: Some #include cleanups
Date: Wed, 31 Dec 2014 02:21:35 +0100
Message-Id: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm contemplating doing some tree-wide spring cleaning, mostly
consisting of removing redundant includes, but also refactoring some
large and heterogeneous headers into smaller pieces.

This patch series consists of low-hanging fruit I picked from
lib/. I've verified that "objdump -d lib/builtin.o" produces identical
output for {allyes,allno,def}config, but this is of course only for
x86_64. There's a small but measurable build time improvement: A
defconfig build of lib/ from a clean tree is consistently .5 seconds
(2 %) faster with these patches. There are lots of other apparently
unused headers in lib/*.c, but I've only removed those where it
actually ends up disappearing from the .cmd dependency file (since
that's where the potential build gain lies, and helps prove that the
header is indeed redundant).

I expect there is much larger speedups to gain from removing includes
from .h files, but that is of course at the same time a huge can of
worms, involving boatloads of tree-wide patches updating users to
include what they use directly. So before I start doing that, I'd like
to hear if people think it would be futile.

Rasmus Villemoes (19):
  lib/interval_tree.c: Simplify includes
  lib/sort.c: Use simpler includes
  lib/dynamic_queue_limits.c: Simplify includes
  lib/halfmd4.c: Simplify includes
  lib/idr.c: Remove redundant include
  lib/genalloc.c: Remove redundant include
  lib/list_sort.c: Rearrange includes
  lib/md5.c: Simplify include
  lib/llist.c: Remove redundant include
  lib/kobject_uevent.c: Remove redundant include
  lib/nlattr.c: Remove redundant include
  lib/plist.c: Remove redundant include
  lib/radix-tree.c: Change to simpler include
  lib/show_mem.c: Remove redundant include
  lib/sort.c: Move include inside #if 0
  lib/stmp_device.c: Replace module.h include
  lib/strncpy_from_user.c: Replace module.h include
  lib/percpu_ida.c: Remove redundant includes
  lib/lcm.c: Replace include

 include/linux/cryptohash.h | 2 ++
 lib/dynamic_queue_limits.c | 4 ++--
 lib/genalloc.c             | 1 -
 lib/halfmd4.c              | 2 +-
 lib/idr.c                  | 1 -
 lib/interval_tree.c        | 4 ++--
 lib/kobject_uevent.c       | 1 -
 lib/lcm.c                  | 2 +-
 lib/list_sort.c            | 7 +++++--
 lib/llist.c                | 1 -
 lib/md5.c                  | 2 +-
 lib/nlattr.c               | 1 -
 lib/percpu_ida.c           | 3 ---
 lib/plist.c                | 1 -
 lib/radix-tree.c           | 2 +-
 lib/show_mem.c             | 1 -
 lib/sort.c                 | 6 +++---
 lib/stmp_device.c          | 3 ++-
 lib/strncpy_from_user.c    | 3 ++-
 19 files changed, 22 insertions(+), 25 deletions(-)

-- 
2.1.3

