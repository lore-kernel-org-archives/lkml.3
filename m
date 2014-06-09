Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbaFIPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:52:10 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42973 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbaFIPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:52:07 -0400
Date: Mon, 9 Jun 2014 11:52:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue changes for v3.16-rc1
Message-ID: <20140609155203.GC22540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Lai simplified worker destruction path and internal workqueue locking
and there are some other minor changes.  Except for the removal of
some long-deprecated interfaces which haven't had any in-kernel user
for quite a while, there shouldn't be any difference to workqueue
users.

Thanks.

The following changes since commit 77668c8b559e4fe2acf2a0749c7c83cde49a5025:

  workqueue: fix a possible race condition between rescuer and pwq-release (2014-04-18 12:33:29 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.16

for you to fetch changes up to 015af06e103fa47af29ada0f564301c81d4973b2:

  kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info (2014-05-28 10:22:34 -0400)

----------------------------------------------------------------
Daeseok Youn (1):
      workqueue: simplify wq_update_unbound_numa() by jumping to use_dfl_pwq if the target cpumask equals wq's

Fabian Frederick (1):
      kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info

Jingoo Han (2):
      workqueue: Remove deprecated flush[_delayed]_work_sync()
      workqueue: Remove deprecated system_nrt[_freezable]_wq

Lai Jiangshan (15):
      workqueue: use manager lock only to protect worker_idr
      workqueue: destroy_worker() should destroy idle workers only
      workqueue: async worker destruction
      workqueue: destroy worker directly in the idle timeout handler
      workqueue: separate iteration role from worker_idr
      workqueue: convert worker_idr to worker_ida
      workqueue: narrow the protection range of manager_mutex
      workqueue: rename manager_mutex to attach_mutex
      workqueue: separate pool-attaching code out from create_worker()
      workqueue: use generic attach/detach routine for rescuers
      workqueue: declare system_highpri_wq
      workqueue: remove unused WORK_CPU_END
      workqueue: remove unused work_clear_pending()
      workqueue: rename first_worker() to first_idle_worker()
      workqueue: remove the confusing POOL_FREEZING

Valdis Kletnieks (1):
      kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info

 include/linux/workqueue.h   |  40 +---
 kernel/workqueue.c          | 448 +++++++++++++++-----------------------------
 kernel/workqueue_internal.h |   2 +
 3 files changed, 154 insertions(+), 336 deletions(-)

--
tejun
