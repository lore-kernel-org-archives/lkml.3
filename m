Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaB0CPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:15:54 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51904 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaB0CPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:15:53 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-70-530e9fd73fa4
Date: Thu, 27 Feb 2014 11:16:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 0/6] add compressing abstraction and multi stream
 support
Message-ID: <20140227021627.GC31407@bbox>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

Code looks good to me and I will queue it into ARM and x86 test tomorrow
and give the result to you with Acked-by.

Thanks for your all works!

On Wed, Feb 26, 2014 at 03:27:53PM +0300, Sergey Senozhatsky wrote:
> This patchset introduces zcomp compression backend abstraction
> adding ability to support compression algorithms other than LZO;
> support for multi compression streams, making parallel compressions
> possible.
> 
> v7->v8 (reviewed by Minchan Kim):
> -- merge patches 'add multi stream functionality' and 'enable multi
>    stream compression support in zram'
> -- return status code from set_max_streams knob and print message on
>    error
> -- do not use atomic type for ->avail_strm
> -- return back: allocate by default only one stream for multi stream backend
> -- wake sleeping write in zcomp_strm_multi_put() only if we put stream
>    to idle list
> -- minor code `nitpicks'
> 
> v6->v7 (reviewed by Minchan Kim):
> -- enable multi and single stream support out of the box (drop
>    ZRAM_MULTI_STREAM config option)
> -- add set_max_stream knob, so we can adjust max number of compression
>    streams in runtime (for multi stream backend at the moment)
> -- minor code `nitpicks'
> 
> v5->v6 (reviewed by Minchan Kim):
> -- handle single compression stream case separately, using mutex locking,
>    to address perfomance regression
> -- handle multi compression stream using spin lock and wait_event()/wake_up()
> -- make multi compression stream support configurable (ZRAM_MULTI_STREAM
>    config option)
> 
> v4->v5 (reviewed by Minchan Kim):
> -- renamed zcomp buffer_lock; removed src len and dst len from
>    compress() and decompress(); not using term `buffer' and
>    `workmem' in code and documentation; define compress() and
>    decompress() functions for LZO backend; not using goto's;
>    do not put idle zcomp_strm to idle list tail.
> 
> v3->v4 (reviewed by Minchan Kim):
> -- renamed compression backend and working memory structs as requested
>    by Minchan Kim; fixed several issues noted by Minchan Kim.
> 
> Sergey Senozhatsky (6):
>   zram: introduce compressing backend abstraction
>   zram: use zcomp compressing backends
>   zram: factor out single stream compression
>   zram: add multi stream functionality
>   zram: add set_max_streams knob
>   zram: document max_comp_streams
> 
>  Documentation/ABI/testing/sysfs-block-zram |   9 +-
>  Documentation/blockdev/zram.txt            |  31 ++-
>  drivers/block/zram/Makefile                |   2 +-
>  drivers/block/zram/zcomp.c                 | 318 +++++++++++++++++++++++++++++
>  drivers/block/zram/zcomp.h                 |  59 ++++++
>  drivers/block/zram/zcomp_lzo.c             |  48 +++++
>  drivers/block/zram/zram_drv.c              |  98 +++++----
>  drivers/block/zram/zram_drv.h              |  10 +-
>  8 files changed, 528 insertions(+), 47 deletions(-)
>  create mode 100644 drivers/block/zram/zcomp.c
>  create mode 100644 drivers/block/zram/zcomp.h
>  create mode 100644 drivers/block/zram/zcomp_lzo.c
> 
> -- 
> 1.9.0.291.g027825b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
