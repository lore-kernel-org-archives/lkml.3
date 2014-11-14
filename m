Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935282AbaKNNMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:12:08 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:58943 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaKNNMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:12:05 -0500
Date: Fri, 14 Nov 2014 08:12:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-ID: <20141114131202.GB21209@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113142333.39fc29592019a397131fb03c@linux-foundation.org>
 <20141113222736.GH2598@htj.dyndns.org>
 <20141113144041.23bff773808562c699507621@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113144041.23bff773808562c699507621@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Nov 13, 2014 at 02:40:41PM -0800, Andrew Morton wrote:
> In that case tjpointer_add() would need to do a kmalloc() for each inode
> which is added to the bdev/cdev, just as ptrset_add() is doing.
> 
> That might require a nasty preload thing.  But really, for just two
> known callers it would be better to require the caller to create the
> storage.
> 
> 
> 	struct tjpointer *new_tpj;
> 
> 	new_tpj = kmalloc(...);
> 	lock();
> 	tjpointer_add(&my_tjp_list, new_tjp, my_pointer);
> 	unlock();
> 
> Basically what I'm saying is nuke the rbtree and use lists.

Hah?  Then, each removal would be O(N) where N is the number of total
block devices and there are cases where massive number of block
devices exist and many are added / removed back-to-back.  I don't
think making those operations O(N^2) is a good idea.

Thanks.

-- 
tejun
