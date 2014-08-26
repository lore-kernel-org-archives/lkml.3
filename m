Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaHZAni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:43:38 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:54820 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaHZAnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:43:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org
Subject: [PATCHSET percpu/for-3.18] add @gfp to init functions of percpu data structures
Date: Mon, 25 Aug 2014 20:43:29 -0400
Message-Id: <1409013812-21700-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's now a pending patchset[1] which implements atomic percpu
allocation.  This patchset propagates @gfp to percpu data structures
so that they can be allocated and initialized from !GFP_KERNEL
contexts too.  This will be used for opportunistic allocations of data
structures embedding percpu constructs in IO path.

This patchset adds @gfp to alloc/init functions of percpu_counter,
[flex_]proportions and percpu-refcount.  We could add separate
alloc/init functions which take @gfp but there aren't too many users
yet, so let's just add it to the existing ones.

This patchset contains the following patches

 0001-percpu_counter-add-gfp-to-percpu_counter_init.patch
 0002-proportions-add-gfp-to-init-functions.patch
 0003-percpu-refcount-add-gfp-to-percpu_ref_init.patch

and is on top of

 [1] [PATCHSET REPOST percpu/for-3.18] percpu: implement atomic allocation support

and avaliable in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git/review-add-gfps

diffstat follows.  Thanks.

 arch/x86/kvm/mmu.c               |    2 +-
 drivers/target/target_core_tpg.c |    3 ++-
 fs/aio.c                         |    4 ++--
 fs/btrfs/disk-io.c               |    8 ++++----
 fs/btrfs/extent-tree.c           |    2 +-
 fs/ext2/super.c                  |    6 +++---
 fs/ext3/super.c                  |    6 +++---
 fs/ext4/super.c                  |   14 +++++++++-----
 fs/file_table.c                  |    2 +-
 fs/quota/dquot.c                 |    2 +-
 fs/super.c                       |    3 ++-
 include/linux/flex_proportions.h |    5 +++--
 include/linux/percpu-refcount.h  |    3 ++-
 include/linux/percpu_counter.h   |   10 ++++++----
 include/linux/proportions.h      |    5 +++--
 include/net/dst_ops.h            |    2 +-
 include/net/inet_frag.h          |    2 +-
 kernel/cgroup.c                  |    6 +++---
 lib/flex_proportions.c           |    8 ++++----
 lib/percpu-refcount.c            |    6 ++++--
 lib/percpu_counter.c             |    4 ++--
 lib/proportions.c                |   10 +++++-----
 mm/backing-dev.c                 |    4 ++--
 mm/mmap.c                        |    2 +-
 mm/nommu.c                       |    2 +-
 mm/page-writeback.c              |    2 +-
 mm/shmem.c                       |    2 +-
 net/dccp/proto.c                 |    2 +-
 net/ipv4/tcp.c                   |    4 ++--
 net/ipv4/tcp_memcontrol.c        |    2 +-
 net/sctp/protocol.c              |    2 +-
 31 files changed, 74 insertions(+), 61 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/1408726399-4436-1-git-send-email-tj@kernel.org
