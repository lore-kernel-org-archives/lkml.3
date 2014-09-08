Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaIHBUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 21:20:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52046 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaIHBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 21:20:30 -0400
Date: Mon, 8 Sep 2014 10:20:25 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.17-rc4
Message-ID: <20140908012025.GF5061@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Up until now, cgroup has allowed any character including '\n' in
cgroup names; unfortunately, as '\n' is used as the row delimiter in
/proc/$PID/cgroup, '\n' in a cgroup name makes the content of the file
ambiguous to parse.  This pull request includes Alban's patch to
disallow '\n' in cgroup names.  While this is a userland visible
behavior change, given the craziness of allowing '\n' and its
implications, I believe the change is justified.  The patch is marked
for -stable backport.

Two other patches from Li to fix a possible oops when cgroup
destruction races against other file operations and one from Vivek to
fix a unified hierarchy devel behavior.

Thanks.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes

for you to fetch changes up to aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

----------------------------------------------------------------
Alban Crequy (1):
      cgroup: reject cgroup names with '\n'

Li Zefan (2):
      cgroup: delay the clearing of cgrp->kn->priv
      cgroup: check cgroup liveliness before unbreaking kernfs

Vivek Goyal (1):
      cgroup: Display legacy cgroup files on default hierarchy

 kernel/cgroup.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

-- 
tejun
