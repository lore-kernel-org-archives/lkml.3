Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3KECIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:08:54 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:49613 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3KECIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:08:52 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, dpquigl@tycho.nsa.gov
Subject: [PATCHSET driver-core-next] kernfs: implement trusted.* xattr support
Date: Mon,  4 Nov 2013 21:08:40 -0500
Message-Id: <1383617322-4386-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(This is for 3.14-rc1.  Posting early for review.  Will refresh and
repost once the next driver-core-next opens.)

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

  driver-core-next 0cae60f91494 ("sysfs: rename sysfs_assoc_lock and explain what it's about")
+ [1] [PATCHSET] sysfs: separate out kernfs, take #2

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

[1] https://lkml.kernel.org/g/1383472398-17812-1-git-send-email-tj@kernel.org
