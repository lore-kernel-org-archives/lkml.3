Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbaKTRDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:03:11 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45096 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbaKTRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:03:06 -0500
Date: Thu, 20 Nov 2014 18:03:13 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Patrick Frisch <patrick@mekufemo6lbi9soa.myfritz.net>,
        Aaron Campbell <aaron@arbor.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [RFC/RFT] multi-layer support for overlay filesystem
Message-ID: <20141120170313.GC3596@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the latest patchset to support multiple read-only layers for overlayfs.
Diffstat is against overlayfs-current branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

I hope to have this included in 3.19.

Please review and test (I can post the full patchset if someone wants that).

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
