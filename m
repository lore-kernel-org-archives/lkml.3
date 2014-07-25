Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320AbaGYRiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934278AbaGYRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:38:12 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 0/5] xgetdents system call
Date: Fri, 25 Jul 2014 12:38:03 -0500
Message-Id: <1406309888-10749-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This system call takes 5 arguments:
fd    - file descriptor of the directory
flags - flags used by xstat
mask  - field mask used to request stat/xattr info
buf   - user buf to return collected info
count - size of user buffer in bytes

xgetdents() should read the directory entries, collect stat
and xattr information for each entry as requested and return
all the data back to the user in a container structure
(linux_xdirent) as part of the supplied user buffer.

Abhi Das (5):
  fs: xstat system call VFS bits
  fs: Add xgetdents system call and xreaddir file operation
  gfs2: Add a dynamic buffer backed by a vector of pages
  gfs2: Add sort functionality with extra parameter
  gfs2: Add xreaddir file operation and supporting functions

 arch/x86/syscalls/syscall_32.tbl |    3 +
 arch/x86/syscalls/syscall_64.tbl |    3 +
 fs/gfs2/Makefile                 |    3 +-
 fs/gfs2/dir.c                    |   80 +--
 fs/gfs2/dir.h                    |   13 +-
 fs/gfs2/export.c                 |    2 +-
 fs/gfs2/file.c                   |   17 +-
 fs/gfs2/incore.h                 |    6 +
 fs/gfs2/inode.c                  |    3 +-
 fs/gfs2/inode.h                  |    5 +
 fs/gfs2/ops_fstype.c             |    4 +
 fs/gfs2/sys.c                    |   26 +-
 fs/gfs2/util.c                   |  363 ++++++++++++++
 fs/gfs2/util.h                   |   47 ++
 fs/gfs2/xattr.c                  |   27 +-
 fs/gfs2/xattr.h                  |   23 +
 fs/gfs2/xreaddir.c               | 1024 ++++++++++++++++++++++++++++++++++++++
 fs/gfs2/xreaddir.h               |   84 ++++
 fs/readdir.c                     |   42 ++
 fs/stat.c                        |  340 ++++++++++++-
 include/linux/fs.h               |    5 +
 include/linux/stat.h             |   16 +-
 include/linux/syscalls.h         |    5 +
 include/uapi/linux/fcntl.h       |    1 +
 include/uapi/linux/stat.h        |  143 ++++++
 25 files changed, 2196 insertions(+), 89 deletions(-)
 create mode 100644 fs/gfs2/xreaddir.c
 create mode 100644 fs/gfs2/xreaddir.h

-- 
1.8.1.4

