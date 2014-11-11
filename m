Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaKKLJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaKKLJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:46 -0500
Date: Tue, 11 Nov 2014 12:09:43 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@parisplace.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] ftruncate, truncate: create fanotify events
Message-ID: <20141111110943.GD10456@quack.suse.cz>
References: <20141007192330.GE30038@quack.suse.cz>
 <1414100107-3750-1-git-send-email-xypron.glpk@gmx.de>
 <20141110203029.GA8125@quack.suse.cz>
 <20141111073415.GA21776@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111073415.GA21776@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-11-14 23:34:15, Christoph Hellwig wrote:
> On Mon, Nov 10, 2014 at 09:30:29PM +0100, Jan Kara wrote:
> >   So what I somewhat dislike about this patch is that notify_change() is
> > sometimes called with dentry and sometimes with path. That way it's not
> > completely clear when fanotify events will be generated and when not.
> > Sadly it isn't easy to provide struct path in all the places where we are
> > calling notify_change() so I'm not sure what would a better solution look
> > like either :(
> 
> I suspect the right thing to do is to split out the truncate path
> from notify_change, as it's fairly different anyway.
  Yeah, that would make sense. I wanted to say it's quite a lot of work to
change all the filesystems (where the separation of truncate path makes
sense as well IMHO) but actually it's possible to just do the separation at
the VFS level and still call ->setattr() fs callback for now. Heinrich will
you look into this?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
