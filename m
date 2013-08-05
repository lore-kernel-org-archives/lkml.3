Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3HEOby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:31:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35949 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3HEObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:31:53 -0400
Date: Mon, 5 Aug 2013 15:31:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: O_TMPFILE fs corruption (Re: Linux 3.11-rc4)
Message-ID: <20130805143149.GA27005@ZenIV.linux.org.uk>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
 <51FF0F18.5020705@mit.edu>
 <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 08:45:16PM -0700, Linus Torvalds wrote:
> The patch looks right to me - we should pass in similar flags for the
> create case as for tmpfile to the filesystem.
> 
> But let's make sure we're all on the same page. Al?

ACK.  It used to happen as a side effect of O_CREAT being required
in the flags, but that broke once we switched to use of O_DIRECTORY.

I've applied both Andi's patches (along with one from Zheng Liu) in
vfs.git #for-linus.  Another thing in there is reiserfs umount
deadlock fix - that one needs to go in all branches starting from
2.6.23.

Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      reiserfs: fix deadlock in umount

Andy Lutomirski (2):
      fs: Fix file mode for O_TMPFILE
      fs: Allow unprivileged linkat(..., AT_EMPTY_PATH) aka flink

Zheng Liu (1):
      vfs: add missing check for __O_TMPFILE in fcntl_init()

Diffstat:
 fs/fcntl.c           |    4 +-
 fs/namei.c           |   10 ++----
 fs/open.c            |    2 +-
 fs/reiserfs/procfs.c |   99 ++++++++++----------------------------------------
 fs/reiserfs/super.c  |    3 +-
 5 files changed, 26 insertions(+), 92 deletions(-)
