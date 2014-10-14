Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaJNO0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:26:06 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:46783 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaJNO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:26:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 0/5] fuse: Add support for mounts from pid/user namespaces
Date: Tue, 14 Oct 2014 16:25:51 +0200
Message-Id: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Here's version 4 of my patches to allow fuse mounts from within user
namespaces. I'm not sure whether or not Eric and I managed to satisfy
your doubts about using fixed namespaces for conversions, but since the
discussion has died down and I've accumulated a few changes I thought it
was time to send new patches.

I also never got any feedback from you about my proposal for restricting
xattrs, so I went ahead and included the patch (with some updates) here.

Changes since v3:
 - Broke out some changes into separate patches.
 - Added missing pid namespace conversion for file locks.
 - Fixed pid/user ns reference leaks when using cuse.
 - Fail operations and invalidate inodes if uids passed over the fuse
   connection don't map into the superblock's user namespace. Also
   dropped vfs patches which are no longer needed after this change.
 - Restrict getting and setting of xattrs to user.* unless the
   privileged_xattrs mount option is passed. This option is only
   permitted for system root.

Thanks,
Seth

Seth Forshee (5):
  fuse: Add support for pid namespaces
  fuse: Support fuse filesystems outside of init_user_ns
  fuse: Restrict allow_other to uids already controlled by the user
  fuse: Support privileged xattrs only with a mount option
  fuse: Allow user namespace mounts

 fs/fuse/dev.c    |  13 +++---
 fs/fuse/dir.c    | 106 ++++++++++++++++++++++++++++++++++---------------
 fs/fuse/file.c   |  38 ++++++++++++------
 fs/fuse/fuse_i.h |  21 ++++++++--
 fs/fuse/inode.c  | 118 +++++++++++++++++++++++++++++++++++++++++--------------
 5 files changed, 213 insertions(+), 83 deletions(-)

