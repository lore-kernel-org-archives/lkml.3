Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaJVVYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:24:55 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:48149 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaJVVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:24:52 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v5 0/4] fuse: Add support for mounts from pid/user namespaces
Date: Wed, 22 Oct 2014 16:24:16 -0500
Message-Id: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another update to the patches to enable userns mounts in fuse.
The changes this time around center on xattrs and allow_other. I'm
considering the following patch to be a prerequisite for this series:

http://lkml.kernel.org/g/252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net

With this patch I'm dropping the xattr restrictions from the v4 patches.
This leaves the situation with xattrs unchanged in init_user_ns. A fuse
userns mount could still supply xattrs which the user would normally be
unable to set, but since the mount will be inaccessible outside of that
userns or its descendants those xattrs will never be seen by the host.

I'm also in agreement with Andy that some decision regarding this patch
should be made before merging the fuse userns support as well:

http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net

Changes since v4:
 - Drop patch to restrict xattrs
 - Update allow_other to restrict based on userns of current rather than
   uid/gid

Thanks,
Seth


Seth Forshee (4):
  fuse: Add support for pid namespaces
  fuse: Support fuse filesystems outside of init_user_ns
  fuse: Restrict allow_other to the superblock's namespace or a
    descendant
  fuse: Allow user namespace mounts

 fs/fuse/dev.c    | 13 ++++----
 fs/fuse/dir.c    | 91 +++++++++++++++++++++++++++++++++++++-------------------
 fs/fuse/file.c   | 38 ++++++++++++++++-------
 fs/fuse/fuse_i.h | 16 +++++++---
 fs/fuse/inode.c  | 81 ++++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 171 insertions(+), 68 deletions(-)

