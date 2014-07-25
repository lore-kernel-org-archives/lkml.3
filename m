Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935195AbaGYRhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:37:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935160AbaGYRhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:37:39 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 0/2] dirreadahead system call
Date: Fri, 25 Jul 2014 12:37:29 -0500
Message-Id: <1406309851-10628-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This system call takes 3 arguments:
fd      - file descriptor of the directory being readahead
*offset - offset in dir from which to resume. This is updated
          as we move along in the directory
count   - The max number of entries to readahead

The syscall is supposed to read upto 'count' entries starting at
'*offset' and cache the inodes corresponding to those entries. It
returns a negative error code or a positive number indicating
the number of inodes it has issued readaheads for. It also
updates the '*offset' value so that repeated calls to dirreadahead
can resume at the right location. Returns 0 when there are no more
entries left.

Abhi Das (2):
  fs: Add dirreadahead syscall and VFS hooks
  gfs2: GFS2's implementation of the dir_readahead file operation

 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   1 +
 fs/gfs2/Makefile                 |   3 +-
 fs/gfs2/dir.c                    |  49 ++++++---
 fs/gfs2/dir.h                    |  15 +++
 fs/gfs2/dir_readahead.c          | 209 +++++++++++++++++++++++++++++++++++++++
 fs/gfs2/file.c                   |   2 +
 fs/gfs2/main.c                   |  10 +-
 fs/gfs2/super.c                  |   1 +
 fs/readdir.c                     |  49 +++++++++
 include/linux/fs.h               |   3 +
 11 files changed, 328 insertions(+), 15 deletions(-)
 create mode 100644 fs/gfs2/dir_readahead.c

-- 
1.8.1.4

