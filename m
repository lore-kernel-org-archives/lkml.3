Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaLQKPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:15:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50485 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLQKPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:15:11 -0500
Date: Wed, 17 Dec 2014 10:15:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] fuse update for 3.19
Message-ID: <20141217101508.GI22149@ZenIV.linux.org.uk>
References: <20141217100202.GA19050@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217100202.GA19050@tucsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:02:02AM +0100, Miklos Szeredi wrote:
> Hi Linus,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
> 
> First part makes sure we don't hold up umount with pending async requests.  In
> addition to being a cleanup, this is a small behavioral change (for the better)
> and unlikely to break anything.  Second part prepares for a cleanup of the fuse
> device I/O code by adding a helper for simple request submission, with some
> savings in line numbers already realized.

Umm...  Make that igrab(file->f_path.dentry->d_inode) igrab(file_inode(file)),
please.  OTOH, that can wait for after merge - it's a trivial followup and
I can take it via vfs.git...
