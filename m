Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaI0VsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 17:48:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaI0VsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 17:48:22 -0400
Date: Sat, 27 Sep 2014 22:48:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikhail Efremov <sem@altlinux.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [git pull] vfs.git for 3.17-rc7
Message-ID: <20140927214819.GX7996@ZenIV.linux.org.uk>
References: <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <CA+55aFyBUKXE87Vou13ni2+=Mbb1Y1n55DXp9gs_0r3e7uLtbQ@mail.gmail.com>
 <CA+55aFwGo8c6iHmb20CfkpBq12Gm+VKBpbZrd=NbSx5R4Cf3fQ@mail.gmail.com>
 <20140927194925.GW7996@ZenIV.linux.org.uk>
 <CA+55aFzUVL9H7zwbVjhBRuJekaOCiYxJCb4V3RyuzjXzykvs+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzUVL9H7zwbVjhBRuJekaOCiYxJCb4V3RyuzjXzykvs+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes + unifying __d_move() and __d_materialise_dentry() +
minimal regression fix for d_path() of victims of overwriting rename()
ported on top of that.  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (7):
      ufs: deal with nfsd/iget races
      pull rehashing and unlocking the target dentry into __d_materialise_dentry()
      don't open-code d_rehash() in d_materialise_unique()
      __d_move(): fold manipulations with ->d_child/->d_subdirs
      __d_materialise_dentry(): flip the order of arguments
      kill __d_materialise_dentry()
      fold unlocking the children into dentry_unlock_parents_for_move()

Linus Torvalds (1):
      fold swapping ->d_name.hash into switch_names()

Mikhail Efremov (1):
      vfs: Don't exchange "short" filenames unconditionally.

Miklos Szeredi (2):
      shmem: fix nlink for rename overwrite directory
      fuse: honour max_read and max_write in direct_io mode

Diffstat:
 fs/dcache.c         |  112 +++++++++++++++++----------------------------------
 fs/direct-io.c      |    2 +-
 fs/fuse/file.c      |    1 +
 fs/ufs/ialloc.c     |    6 ++-
 fs/ufs/namei.c      |    4 ++
 include/linux/uio.h |    2 +-
 mm/iov_iter.c       |   14 ++++---
 mm/shmem.c          |    4 +-
 8 files changed, 60 insertions(+), 85 deletions(-)
