Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3IFSmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:42:37 -0400
Received: from kanga.kvack.org ([205.233.56.17]:38970 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3IFSme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:42:34 -0400
Date: Fri, 6 Sep 2013 14:42:34 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [AIO] aio-next changes for 3.12
Message-ID: <20130906184234.GE8598@kvack.org>
References: <20130906183923.GD8598@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906183923.GD8598@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 02:39:23PM -0400, Benjamin LaHaise wrote:
> Hello Andrew,

This should have included Al as well.  Sorry for the oversight.

		-ben

> Please consider pulling the following changes from my aio-next tree at:
> 
> 	git://git.kvack.org/~bcrl/aio-next.git
> 
> which covers changes since commit 47188d39b5deeebf41f87a02af1b3935866364cf.
> 
> These changes have been baking in the linux-next tree for the last few 
> months.  The bulk of this work comes from Kent Overstreet which reworks 
> and improve performance of the AIO core and lays the foundation for his 
> batch completion work.  Also included is Gu Zheng's cleanups of my work 
> to enable page migration in the AIO core, which fixes hot unplug of 
> memory pinned by AIO.  The last few patches are fixes by me for some of 
> the issues uncovered in this change set during its testing.
> 
> 		-ben
> 
> Benjamin LaHaise (8):
>   aio: fix build when migration is disabled
>   aio: double aio_max_nr in calculations
>   aio: convert the ioctx list to table lookup v3
>   aio: be defensive to ensure request batching is non-zero instead of
>     BUG_ON()
>   aio: fix error handling and rcu usage in "convert the ioctx list to
>     table lookup v3"
>   aio: table lookup: verify ctx pointer
>   aio: remove unnecessary debugging from aio_free_ring()
>   aio: fix rcu sparse warnings introduced by ioctx table lookup patch
> 
> Gu Zheng (2):
>   fs/anon_inode: Introduce a new lib function
>     anon_inode_getfile_private()
>   fs/aio: Add support to aio ring pages migration
> 
> Kent Overstreet (9):
>   aio: reqs_active -> reqs_available
>   aio: percpu reqs_available
>   aio: percpu ioctx refcount
>   aio: io_cancel() no longer returns the io_event
>   aio: Don't use ctx->tail unnecessarily
>   aio: Kill aio_rw_vect_retry()
>   aio: Kill unneeded kiocb members
>   aio: Kill ki_users
>   aio: Kill ki_dtor
> 
> Peng Tao (1):
>   staging/lustre: kiocb->ki_left is removed
> 
>  drivers/staging/android/logger.c           |   2 +-
>  drivers/staging/lustre/lustre/llite/file.c |   4 +-
>  drivers/usb/gadget/inode.c                 |   9 +-
>  fs/aio.c                                   | 713 ++++++++++++++++++-----------
>  fs/anon_inodes.c                           |  66 +++
>  fs/block_dev.c                             |   2 +-
>  fs/nfs/direct.c                            |   1 -
>  fs/ocfs2/file.c                            |   6 +-
>  fs/read_write.c                            |   3 -
>  fs/udf/file.c                              |   2 +-
>  include/linux/aio.h                        |  21 +-
>  include/linux/anon_inodes.h                |   3 +
>  include/linux/migrate.h                    |   3 +
>  include/linux/mm_types.h                   |   5 +-
>  kernel/fork.c                              |   2 +-
>  mm/migrate.c                               |   2 +-
>  mm/page_io.c                               |   1 -
>  net/socket.c                               |  15 +-
>  18 files changed, 547 insertions(+), 313 deletions(-)
> 
> -- 
> 1.8.2.1
> -- 
> "Thought is the essence of where you are now."

-- 
"Thought is the essence of where you are now."
