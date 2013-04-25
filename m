Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3DYFIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:08:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45033 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3DYFID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <1366857785-17117-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1366857785-17117-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Thu, 25 Apr 2013 14:08:03 +0900
Message-ID: <CAKYAXd84n_4-pe_dN0EQLVsMSpHHQeQq593Uv0ffvij+3sf-ig@mail.gmail.com>
Subject: Re: [PATCH] f2fs: give a chance to merge IOs by IO scheduler
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Previously, background GC submits many 4KB read requests to load victim
> blocks
> and/or its (i)node blocks.
>
> ...
> f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb61, blkaddr = 0x3b964ed
> f2fs_gc : block_rq_complete: 8,16 R () 499854968 + 8 [0]
> f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb6f, blkaddr = 0x3b964ee
> f2fs_gc : block_rq_complete: 8,16 R () 499854976 + 8 [0]
> f2fs_gc : f2fs_readpage: ino = 1, page_index = 0xb79, blkaddr = 0x3b964ef
> f2fs_gc : block_rq_complete: 8,16 R () 499854984 + 8 [0]
> ...
>
> However, by the fact that many IOs are sequential, we can give a chance to
> merge
> the IOs by IO scheduler.
> In order to do that, let's use blk_plug.
>
> ...
> f2fs_gc : f2fs_iget: ino = 143
> f2fs_gc : f2fs_readpage: ino = 143, page_index = 0x1c6, blkaddr = 0x2e6ee
> f2fs_gc : f2fs_iget: ino = 143
> f2fs_gc : f2fs_readpage: ino = 143, page_index = 0x1c7, blkaddr = 0x2e6ef
> <idle> : block_rq_complete: 8,16 R () 1519616 + 8 [0]
> <idle> : block_rq_complete: 8,16 R () 1519848 + 8 [0]
> <idle> : block_rq_complete: 8,16 R () 1520432 + 96 [0]
> <idle> : block_rq_complete: 8,16 R () 1520536 + 104 [0]
> <idle> : block_rq_complete: 8,16 R () 1521008 + 112 [0]
> <idle> : block_rq_complete: 8,16 R () 1521440 + 152 [0]
> <idle> : block_rq_complete: 8,16 R () 1521688 + 144 [0]
> <idle> : block_rq_complete: 8,16 R () 1522128 + 192 [0]
> <idle> : block_rq_complete: 8,16 R () 1523256 + 328 [0]
> ...
>
> Note that this issue should be addressed in checkpoint, and some readahead
> flows too.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks reasonable to me :)
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
Thanks~
