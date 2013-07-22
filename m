Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3GVC1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 22:27:18 -0400
Received: from mdfmta010.mxout.tbr.inty.net ([91.221.168.51]:56912 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755160Ab3GVC1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 22:27:15 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2013 22:27:15 EDT
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-embedded@vger.kernel.org
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/2] Squashfs: add LZ4 compression
Date: Mon, 22 Jul 2013 03:21:01 +0100
Message-Id: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Now that LZ4 compression support is in 3.11-rc1, I have written the
following two patches for Squashfs to use it.

Phillip Lougher (2):
  Squashfs: add LZ4 compression support
  Squashfs: Add LZ4 compression configuration option

 Documentation/filesystems/squashfs.txt |    8 +-
 fs/squashfs/Kconfig                    |   15 +++
 fs/squashfs/Makefile                   |    1 +
 fs/squashfs/decompressor.c             |    7 ++
 fs/squashfs/decompressor.h             |    4 +
 fs/squashfs/lz4_wrapper.c              |  163 ++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs_fs.h              |    1 +
 7 files changed, 195 insertions(+), 4 deletions(-)
 create mode 100644 fs/squashfs/lz4_wrapper.c

These patches are also available in the git tree here:

browse: https://git.kernel.org/cgit/linux/kernel/git/pkl/squashfs-lz4.git
git clone: git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-lz4.git

LZ4 support has (obviously) also been added to the squashfs-tools
(Mksquashfs and Unsquashfs).  This is available from the Squashfs-tools
git repository here:

browse: https://git.kernel.org/cgit/fs/squashfs/squashfs-tools.git
git clone: git://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git

When building the squashfs-tools edit the Makefile to enable LZ4
support (by default it is disabled).

LZ4 compression can be specified by using the -comp option, e.g.
% mksquashfs xxx img.sqsh -comp lz4

The use of LZ4 high compression can be specified using -Xhc, e.g.

% mksquashfs xxx img.sqsh -comp lz4 -Xhc

Phillip
