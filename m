Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaILOmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:42:20 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:62184 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaILOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:42:18 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 0/4] fuse: Add support for mounts from pid/user namespaces
Date: Fri, 12 Sep 2014 09:41:41 -0500
Message-Id: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third round of patches for making it possible to mount with fuse from
within user namespaces. The only change since v2 is the addition of a
patch to ensure real root is capable towards inodes whose uid/gid is
invalid.

Thanks,
Seth


Seth Forshee (4):
  vfs: Check for invalid i_uid in may_follow_link()
  vfs,userns: Ensure real root is always capable towards inodes
  fuse: Translate pids passed to userspace into pid namespaces
  fuse: Add support for mounts from user namespaces

 fs/fuse/dev.c       | 13 +++++++------
 fs/fuse/dir.c       | 46 +++++++++++++++++++++++++++++++++-------------
 fs/fuse/fuse_i.h    |  8 ++++++++
 fs/fuse/inode.c     | 31 +++++++++++++++++++++++--------
 fs/inode.c          |  3 +++
 fs/namei.c          |  2 +-
 kernel/capability.c |  6 +++++-
 7 files changed, 80 insertions(+), 29 deletions(-)

