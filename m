Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaASKhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:37:36 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51123 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaASKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:33 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/5] percpu_ida+Co: Make percpu_ida_alloc accept task state bitmask
Date: Sun, 19 Jan 2014 10:16:51 +0000
Message-Id: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello Linus,

Here is the series for converting percpu_ida_alloc() + consumer
usage to accept the task state bitmask parameter, w/o the extra
legacy gfp_t wrapper.

Also, given that the first three patches needs to be backported
to different kernel versions, the series has been broken up into
seperate commits for blk-mq (v3.13.y) and target/* (v3.12.y) with
the minimal set of changes marked for stable.

The last two patches propigate task state bitmask usage further
up the blk-mq + target/iscsi stack, and as improvements are not
marked for stable code.

CC'ing Ingo + Peter for TASK_RUNNING + prepare_to_wait() bit.

Thank you,

--nab

Kent Overstreet (1):
  percpu_ida: Make percpu_ida_alloc accept task state bitmask

Nicholas Bellinger (4):
  blk-mq: Update percpu_ida_alloc to use task state bitmask
  target: Update percpu_ida_alloc to use task state bitmask
  blk-mq: Convert gfp_t parameters to task state bitmask
  target/iscsi: Convert gfp_t parameter to task state bitmask

 block/blk-core.c                         |    4 +++-
 block/blk-flush.c                        |    2 +-
 block/blk-mq-tag.c                       |   14 +++++++-------
 block/blk-mq-tag.h                       |    2 +-
 block/blk-mq.c                           |   28 ++++++++++++++--------------
 drivers/infiniband/ulp/isert/ib_isert.c  |   14 +++++++-------
 drivers/target/iscsi/iscsi_target.c      |   14 +++++++-------
 drivers/target/iscsi/iscsi_target_util.c |    9 ++++++---
 drivers/target/iscsi/iscsi_target_util.h |    2 +-
 drivers/vhost/scsi.c                     |    2 +-
 include/linux/blk-mq.h                   |    4 ++--
 include/linux/percpu_ida.h               |    3 ++-
 include/target/iscsi/iscsi_transport.h   |    2 +-
 lib/percpu_ida.c                         |   17 +++++++++++------
 14 files changed, 64 insertions(+), 53 deletions(-)

-- 
1.7.10.4

