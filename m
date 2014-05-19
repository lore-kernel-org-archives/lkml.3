Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaESXJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:09:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:09:47 -0400
Date: Mon, 19 May 2014 16:09:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by
 fls
Message-Id: <20140519160946.84e79c832dfc4db0fbae573b@linux-foundation.org>
In-Reply-To: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
References: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 22:38:15 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> Replace while blocksize;shift by fls -1
> 
> Suggested-By: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> v2: rebased on top of mmots
>     compiles without including bitops
> 
>  fs/hfsplus/wrapper.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
> index 284c90f..8e8cf50d 100644
> --- a/fs/hfsplus/wrapper.c
> +++ b/fs/hfsplus/wrapper.c
> @@ -231,9 +231,7 @@ reread:
>  	if (blocksize < HFSPLUS_SECTOR_SIZE || ((blocksize - 1) & blocksize))
>  		goto out_free_backup_vhdr;
>  	sbi->alloc_blksz = blocksize;
> -	sbi->alloc_blksz_shift = 0;
> -	while ((blocksize >>= 1) != 0)
> -		sbi->alloc_blksz_shift++;
> +	sbi->alloc_blksz_shift = fls(blocksize) - 1;
>  	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);

fls() always makes my brain hurt.  ilog() is nicer?
