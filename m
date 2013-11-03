Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3KCSZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:25:36 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:35253 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KCSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131103015803.GK13318@ZenIV.linux.org.uk>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
Date: Sun, 3 Nov 2013 10:25:32 -0800
X-Google-Sender-Auth: OztDisUn67cUoRj7M6F74uezqKY
Message-ID: <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
Subject: Re: [git pull] fixes for 3.12-final
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Bruce Fields <bfields@fieldses.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh.

This is too late since I want to do 3.12 today, and it seems to not be
a regression - from what I can tell, the problem has always existed,
no?

So I'll consider this post-3.12. However, it also strikes me that we
should just clean things up, and make "i_ino" be an u64, and be able
to do this without the vfs_getattr_nosec() games.

Hmm?

             Linus

On Sat, Nov 2, 2013 at 6:58 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Exportfs fix from bfields.  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
>
> Shortlog:
> J. Bruce Fields (2):
>       vfs: split out vfs_getattr_nosec
>       exportfs: fix 32-bit nfsd handling of 64-bit inode numbers
>
> Diffstat:
>  fs/exportfs/expfs.c |   18 ++++++++++++++++--
>  fs/stat.c           |   31 +++++++++++++++++++++++++------
>  include/linux/fs.h  |    1 +
>  3 files changed, 42 insertions(+), 8 deletions(-)
