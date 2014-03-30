Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaC3Uzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 16:55:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaC3Uzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 16:55:40 -0400
Date: Sun, 30 Mar 2014 21:55:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs fixes
Message-ID: <20140330205537.GM18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
 <CA+55aFw=1TcAtk-0tFp7rP-8c2dv8ap4tr-RKiMsULWEC=i0qA@mail.gmail.com>
 <20140323164526.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFxK8+Fm3gbTyxnpy_AWJKtoJdOPsYV9-vbnOTchO=DKAw@mail.gmail.com>
 <CA+icZUXoTVbZhopEhwQfxRF0ka1x6J3SmA9YHarN1UWA6QGCBw@mail.gmail.com>
 <CA+55aFxvACwdNuswQsTENWdmRnjKR_LgThtnAVTBQ91gvDpWvg@mail.gmail.com>
 <CA+icZUWD7NekSyNa2Keg=+teDCGg-Ttc5Xb4wfKA-56FMwGSeg@mail.gmail.com>
 <CA+55aFwKqDzNCd1wQYZqKXb3DDj2bHYjHCYjDAkWJwPhuvR17A@mail.gmail.com>
 <20140330203307.GL18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330203307.GL18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 09:33:07PM +0100, Al Viro wrote:
> Al, finally back to life and digging himself from under ~5e3 mails in l-k
> mailbox...

        Several fixes; a couple of fdget_pos()-related ones from Eric Biggers,
prepend_name() fix (bug was reported by many people, Imre and Jan being the
ones I'd been able to find addresses of), plus a series of fixes for bug
found by Max Kellermann - missing checks for false negatives from
__lookup_mnt() in fs/namei.c + switching mnt_hash to hlist, turning
the races between __lookup_mnt() and hash modifications into
false negatives from __lookup_mnt() (instead of hangs).

Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Commit ID of that branch should be 7fc5aaa083922420e2dec5d985420cb5f959b1ce;
diffs are the same as what sat there since last Sunday, commit messages
got updated a bit.  Should've propagated by now...

Shortlog:
Al Viro (6):
      make prepend_name() work correctly when called with negative *buflen
      rcuwalk: recheck mount_lock after mountpoint crossing attempts
      resizable namespace.c hashes
      keep shadowed vfsmounts together
      don't bother with propagate_mnt() unless the target is shared
      switch mnt_hash to hlist

Eric Biggers (2):
      vfs: atomic f_pos access in llseek()
      vfs: Don't let __fdget_pos() get FMODE_PATH files

Diffstat:
 fs/dcache.c     |    4 +-
 fs/file.c       |   19 ++----
 fs/mount.h      |    4 +-
 fs/namei.c      |   29 ++++-----
 fs/namespace.c  |  177 ++++++++++++++++++++++++++++++++++++-------------------
 fs/pnode.c      |   26 ++++----
 fs/pnode.h      |    4 +-
 fs/read_write.c |    4 +-
 8 files changed, 155 insertions(+), 112 deletions(-)
