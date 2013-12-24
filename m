Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3LXO3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:29:36 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:34848 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3LXO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:29:27 -0500
Date: Tue, 24 Dec 2013 09:29:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.13-rc5
Message-ID: <20131224142923.GC3512@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Linus.

Two fixes.  One fixes a bug in the error path of cgroup_create().  The
other changes cgrp->id lifetime rule so that the id doesn't get
recycled before all controller states are destroyed.  This premature
id recycling made memcg malfunction.

The following changes since commit e605b36575e896edd8161534550c9ea021b03bc0:

  cgroup: fix cgroup_subsys_state leak for seq_files (2013-11-27 18:16:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.13-fixes

for you to fetch changes up to c1a71504e9715812a2d15e7c03b5aa147ae70ded:

  cgroup: don't recycle cgroup id until all csses' have been destroyed (2013-12-17 08:11:52 -0500)

Thanks.
----------------------------------------------------------------
Li Zefan (1):
      cgroup: don't recycle cgroup id until all csses' have been destroyed

Tejun Heo (1):
      cgroup: fix cgroup_create() error handling path

 kernel/cgroup.c | 50 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

-- 
tejun
