Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaCCWKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:10:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36235 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCCWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:10:16 -0500
Date: Mon, 3 Mar 2014 22:10:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303221014.GN18016@ZenIV.linux.org.uk>
References: <53022DB1.4070805@gmail.com>
 <CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
 <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
 <20140303214536.GK18016@ZenIV.linux.org.uk>
 <CA+55aFwZ_tcK+G2SZynDzv6w=y3UNobVE5SOH9+Y6x2QQCW7tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwZ_tcK+G2SZynDzv6w=y3UNobVE5SOH9+Y6x2QQCW7tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 02:01:33PM -0800, Linus Torvalds wrote:
> On Mon, Mar 3, 2014 at 1:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > And it looks like you've missed compat counterparts.
> 
> Grr. Yes, I missed them for compat_readv/writev - even though I
> grepped for various users, but I grepped for all the *other* cases (ie
> vfs_{read|write|llseek}). That means that the locker helper can't be
> static to fs/read_write.c. Oh well.

It can - compat read/write/read/writev are also there these days.  I think
that's the only thing you've missed, but I've several more places to trace
before I'll be sure.
