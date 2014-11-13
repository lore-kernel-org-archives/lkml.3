Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbaKMW1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:27:41 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:59240 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:27:39 -0500
Date: Thu, 13 Nov 2014 17:27:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-ID: <20141113222736.GH2598@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Nov 13, 2014 at 02:23:33PM -0800, Andrew Morton wrote:
> This seems rather slow and bloaty.  Why not
> 
> struct tjpointer {
> 	struct list_head list;
> 	void *pointer;
> };
> 
> And then callers do things like
> 
> 	struct tjpointer *tjp;
> 
> 	lock();
> 
> 	for_each_tjpointer(tjp, &my_tjpointer_list) {
> 		foo(tjp->ptr);
> 	}
> 
> 	tjpointer_del(tjp);
> 
> 	unlock();
> 
> That's less storage, vastly less support code, insertion and removal
> are O(1) and it doesn't need the ghastly preload thing.

The goal is moving the memory necessary for indexing to the indexer
instead of the indexees.  In the above case, the indexee would have to
either embed tjpointer inside it or at least have a pointer pointing
at it.  With ptrset, all necessary memory areas are allocated on the
ptrset side.  This is used to remove inode->i_devices list_head which
is currently occupying two pointers on all inodes while being used
only for block and char dev inodes in the cold paths.

Thanks.

-- 
tejun
