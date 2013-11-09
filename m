Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3KIItj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 03:49:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KIIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 03:49:38 -0500
Date: Sat, 9 Nov 2013 00:49:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the
 current mount namespace
Message-ID: <20131109084916.GA21413@infradead.org>
References: <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <87d2n6xpan.fsf_-_@xmission.com>
 <20131103035406.GA8537@ZenIV.linux.org.uk>
 <87bo1u8vmf.fsf@xmission.com>
 <20131108213551.GR13318@ZenIV.linux.org.uk>
 <87fvr61qtg.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvr61qtg.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 02:17:31PM -0800, Eric W. Biederman wrote:
> > Read what you've written a few lines above.  The part about target->i_mutex
> > being held.
> 
> That works for the rename as unlink case but we don't hold
> old_dentry->d_inode->i_mutex which is what is needed to prevent a mount
> on the dentry we are renaming.

It will be held in 3.13.

