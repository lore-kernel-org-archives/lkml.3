Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaLIKhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:37:33 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52373 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaLIKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:37:31 -0500
Date: Tue, 9 Dec 2014 11:37:45 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] multi-layer support for overlay filesystem
Message-ID: <20141209103745.GA32280@tucsk.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This adds support for multiple read-only layers to overlayfs.  It also makes the
writable upper layer optional.

Thanks,
Miklos

---
Miklos Szeredi (12):
      ovl: check whiteout while reading directory
      ovl: make path-type a bitmap
      ovl: dont replace opaque dir
      ovl: add mutli-layer infrastructure
      ovl: helper to iterate layers
      ovl: multi-layer readdir
      ovl: multi-layer lookup
      ovl: allow statfs if no upper layer
      ovl: mount: change order of initialization
      ovl: improve mount helpers
      ovl: make upperdir optional
      ovl: support multiple lower layers

---
 Documentation/filesystems/overlayfs.txt |  12 +
 fs/overlayfs/copy_up.c                  |   4 +-
 fs/overlayfs/dir.c                      |  24 +-
 fs/overlayfs/inode.c                    |   9 +-
 fs/overlayfs/overlayfs.h                |  14 +-
 fs/overlayfs/readdir.c                  | 120 +++-----
 fs/overlayfs/super.c                    | 521 ++++++++++++++++++++------------
 7 files changed, 427 insertions(+), 277 deletions(-)
