Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3KGBqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:46:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40175 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3KGBqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:46:06 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 00/11] rbtree: postorder iteration: fix, add tests, and use in various places
Date: Wed,  6 Nov 2013 17:42:29 -0800
Message-Id: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110701-8236-0000-0000-000003831196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New in v2:
1: Jan Kara's fix for rbtree_postorder_for_each_entry_safe() for when gcc tries to optimize it.
2,3: test the above mentioned macro and reorder the test struct to catch anther class of errors.

Unchanged from v1:
4-11: use the postorder_for_each() in various locations.

--
Cody P Schafer (10):
  rbtree/test: move rb_node to the middle of the test struct
  rbtree/test: test rbtree_postorder_for_each_entry_safe()
  net ipset: use rbtree postorder iteration instead of opencoding
  trace/trace_stat: use rbtree postorder iteration helper instead of
    opencoding
  fs/ubifs: use rbtree postorder iteration helper instead of opencoding
  fs/ext4: use rbtree postorder iteration helper instead of opencoding
  fs/jffs2: use rbtree postorder iteration helper instead of opencoding
  fs/ext3: use rbtree postorder iteration helper instead of opencoding
  mtd/ubi: use rbtree postorder iteration helper instead of opencoding
  sh/dwarf: use rbtree postorder iteration helper instead of solution
    using repeated rb_erase()

Jan Kara (1):
  rbtree: Fix rbtree_postorder_for_each_entry_safe() iterator

 arch/sh/kernel/dwarf.c                     | 18 +++--------
 drivers/mtd/ubi/attach.c                   | 49 +++++-------------------------
 drivers/mtd/ubi/wl.c                       | 25 ++-------------
 fs/ext3/dir.c                              | 36 +++-------------------
 fs/ext4/block_validity.c                   | 33 +++-----------------
 fs/ext4/dir.c                              | 35 +++------------------
 fs/jffs2/nodelist.c                        | 28 ++---------------
 fs/jffs2/readinode.c                       | 26 ++--------------
 fs/ubifs/debug.c                           | 22 ++------------
 fs/ubifs/log.c                             | 21 ++-----------
 fs/ubifs/orphan.c                          | 21 ++-----------
 fs/ubifs/recovery.c                        | 21 ++-----------
 fs/ubifs/super.c                           | 24 +++------------
 fs/ubifs/tnc.c                             | 22 ++------------
 include/linux/rbtree.h                     | 16 +++++-----
 kernel/trace/trace_stat.c                  | 42 ++++---------------------
 lib/rbtree_test.c                          | 13 +++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c | 27 +++-------------
 18 files changed, 81 insertions(+), 398 deletions(-)

-- 
1.8.4.2

