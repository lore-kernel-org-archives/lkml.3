Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab3KWWkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:40:09 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45797 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3KWWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:40:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: [PATCHSET REPOST driver-core-next] kernfs: implement trusted.* xattr support
Date: Sat, 23 Nov 2013 17:40:00 -0500
Message-Id: <1385246402-1407-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is repost of [L], rebased on top of the refreshed patches.

kernfs inherited "security.*" xattr support from sysfs but for it to
be useable for cgroupfs, it needs to support "trusted.*" too.  This
patchset adds "trusted.*" xattr support using simple_xattr*().

Note that the existing "security.*" support is gimped in that it
doesn't include remove/get/list.  This patchset implements all
operations for "trusted.*" but doesn't change "security.*" support.

David P. Quigley, can you please comment on this?  It doesn't seem
like adding it would be too difficult.  Why don't we have it yet?  Are
they unnecessary?

This patchset contains the following two patches.

 0001-kernfs-update-sysfs_init_inode_attrs.patch
 0002-kernfs-implement-trusted.-xattr-support.patch

0001 preps and 0002 implements.

This patchset is on top of

  v3.13-rc1 6ce4eac1f600 ("Linux 3.13-rc1")
+ [1] sysfs: handle duplicate removal attempts in sysfs_remove_group()
+ [2] sysfs: use a separate locking class for open files depending on mmap
+ [3] sysfs: separate out kernfs, take #3

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-xattr

diffstat follows.  Thanks.

 fs/kernfs/dir.c             |   12 +++-
 fs/kernfs/inode.c           |  123 ++++++++++++++++++++++++++++----------------
 fs/kernfs/kernfs-internal.h |   13 +++-
 fs/kernfs/symlink.c         |    3 +
 4 files changed, 103 insertions(+), 48 deletions(-)

--
tejun

[L] https://lkml.kernel.org/g/1383617322-4386-1-git-send-email-tj@kernel.org
[1] https://lkml.kernel.org/g/20131123183508.GA28162@mtj.dyndns.org
[2] https://lkml.kernel.org/g/20131123183540.GB28162@mtj.dyndns.org
[3] https://lkml.kernel.org/g/1385245346-856-1-git-send-email-tj@kernel.org
