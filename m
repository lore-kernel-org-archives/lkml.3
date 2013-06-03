Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3FCDjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 23:39:25 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37180 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3FCDjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 23:39:20 -0400
Date: Sun, 2 Jun 2013 20:39:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.10-rc4
Message-ID: <20130603033924.GC6071@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains

* Fix for yet another xattr bug which may lead to NULL deref.

* A subtle bug in for_each_descendant_pre().  This bug requires quite
  specific conditions to trigger and isn't too likely to actually
  happen in the wild, but maybe that just makes it that much more
  nastier.

* A warning message added for silly cgroup re-mount (not -o remount,
  but unmount followed by mount) behavior.

The changes are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.10-fixes

for you to fetch changes up to 2a0ff3fbe39bc93f719ff857e5a359d9780579ff:

  cgroup: warn about mismatching options of a new mount of an existing hierarchy (2013-05-29 07:59:39 +0900)

Thanks.

----------------------------------------------------------------
Jeff Liu (1):
      cgroup: warn about mismatching options of a new mount of an existing hierarchy

Li Zefan (1):
      cgroup: initialize xattr before calling d_instantiate()

Tejun Heo (1):
      cgroup: fix a subtle bug in descendant pre-order walk

 include/linux/cgroup.h |  2 +-
 kernel/cgroup.c        | 31 ++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

--
tejun
