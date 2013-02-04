Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3BDJOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:14:55 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:41595 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3BDJOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:14:53 -0500
Date: Mon, 4 Feb 2013 17:29:06 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/6 RFC] Mapping range lock
Message-ID: <20130204092906.GA7503@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
 <20130131160757.06d7f1c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131160757.06d7f1c2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 04:07:57PM -0800, Andrew Morton wrote:
[snip]
> > c) i_mutex doesn't allow any paralellism of operations using it and some
> >    filesystems workaround this for specific cases (e.g. DIO reads). Using
> >    range locking allows for concurrent operations (e.g. writes, DIO) on
> >    different parts of the file. Of course, range locking itself isn't
> >    enough to make the parallelism possible. Filesystems still have to
> >    somehow deal with the concurrency when manipulating inode allocation
> >    data. But the range locking at least provides a common VFS mechanism for
> >    serialization VFS itself needs and it's upto each filesystem to
> >    serialize more if it needs to.
> 
> That would be useful to end-users, but I'm having trouble predicting
> *how* useful.

Hello Andrew,

I believe this would be useful for the end-user, at least for dio user, e.g.
database.  Now when we want to issue a direct io, i_mutex will serialize
concurrent reader/writer.  Some filesystems (xfs and ext4) try not to take
this locking in some conditions to improve the performance, especially for the
latency, because we don't need to wait on this locking.  But there are still
some cases that need to take it.  So range locking can make us reduce the
contention as far as possible.

Regards,
						- Zheng
