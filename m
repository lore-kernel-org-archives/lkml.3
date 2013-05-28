Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab3E1RhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:37:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784Ab3E1RhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:37:00 -0400
Date: Tue, 28 May 2013 10:36:31 -0700
From: Zach Brown <zab@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com
Subject: Re: [RFC PATCH] vfs: add permute operation
Message-ID: <20130528173631.GB2363@lenny.home.zabbo.net>
References: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130527153313.GC1842@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some quick thoughts:

> Permute the location of files.  E.g.  'permute(A, B, C)' is equivalent to A->B,
> B->C and C->A.  This is essentially a series of renames done as a single atomic
> operation.

Hmm.  Can we choose a more specific name than 'permute'?  To me,
->permute() tells me just as much about the operation as
->do_something().  {multi,bulk,mass}_rename()?  renamev()?

Maybe it's just me.

> to be done as an atomic operation.  We could add whiteout support to filesystem
> ops to perform the creation or removal of whiteouts atomically, but it would
> complicate many filesystem ops needlessly.
> 
> Alternatively we can add a generic permute operation and add whiteout support to
> the VFS which utilizes this to perform the operations atomically.

I certainly like the sound of this.

> +static void sort_parents3(struct dentry **p)
> +void sort_parents(struct dentry **p, unsigned *nump)

Yikes, that's a bunch of fiddly code.  Is it *really* worth all that to
avoid calling the generic sort helpers?

> +	if (WARN_ON(num > PERMUTE_MAX) ||
> +	    WARN_ON(num < 2))
> +		return -EINVAL;

And in other places this is a BUG?  Why not, like the syscall, limit the
arguments to three if we're serious about that limitation?

- z
