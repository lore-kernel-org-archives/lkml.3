Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3GANwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:52:36 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39275 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GANwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:52:35 -0400
Date: Mon, 1 Jul 2013 06:52:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [GIT PULL] per-cpu changes for v3.11-rc1
Message-ID: <20130701135220.GC11408@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains Kent's per-cpu reference counter.  It has
gone through several iterations since the last time and the dynamic
allocation is gone.  The usual usage is relatively straight-forward
although async kill confirm interface, which is not used int most
cases, is somewhat icky.  There also are some interface concerns -
e.g. I'm not sure about passing in @relesae callback during init as
that becomes funny when we later implement synchronous kill_and_drain
- but nothing too serious and it's quite useable now.

cgroup_subsys_state refcnting has already been converted and we should
convert module refcnt (Kent?).

Please pull from the following branch to receive the per-cpu reference
counter.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.11

Thanks.

----------------------------------------------------------------
Kent Overstreet (2):
      percpu: implement generic percpu refcounting
      percpu-refcount: Don't use silly cmpxchg()

Tejun Heo (6):
      percpu-refcount: consistently use plain (non-sched) RCU
      percpu-refcount: cosmetic updates
      percpu-refcount: add __must_check to percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
      percpu-refcount: implement percpu_ref_cancel_init()
      percpu-refcount: implement percpu_tryget() along with percpu_ref_kill_and_confirm()
      percpu-refcount: use RCU-sched insted of normal RCU

 include/linux/percpu-refcount.h | 174 ++++++++++++++++++++++++++++++++++++++++
 lib/Makefile                    |   2 +-
 lib/percpu-refcount.c           | 158 ++++++++++++++++++++++++++++++++++++
 3 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

-- 
tejun
