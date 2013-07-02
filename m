Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3GBSEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 14:04:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab3GBSEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 14:04:51 -0400
Date: Tue, 2 Jul 2013 20:04:47 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Message-ID: <20130702180447.GB16282@quack.suse.cz>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-07-13 10:18:32, Linus Torvalds wrote:
> Hmm I'm getting this compiler warning:
> 
>   fs/ext4/inode.c: In function ‘ext4_writepages’:
>   fs/ext4/inode.c:2219:6: warning: ‘err’ may be used uninitialized in
> this function [-Wmaybe-uninitialized]
> 
> and I think the compiler is right to warn. The 'err' variable is set
> inside a whilte() and an if() statement, and it is not at all obvious
> that those codepaths are always taken.
> 
> Maybe that "map->m_len" is always guaranteed to be nonzero, and the
> "while()" statement could be a "do { } while()" one. But if so, make
> it so, don't write code as if it might never be executed, when the
> return value seems to *depend* on it being executed.
  That's caused by my patches (only for certain gcc versions). map->m_len
is guaranteed to be > 0 in the first iteration (the function is called from
under if (map->m_len > 0)). I though Ted silenced that warning but
apparently he did not. The cleanest fix is likely to make a do-while loop
from that one. I'll send Ted a patch for that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
