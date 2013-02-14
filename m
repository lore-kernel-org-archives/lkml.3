Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3BNLiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:38:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757468Ab3BNLit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:38:49 -0500
Date: Thu, 14 Feb 2013 12:38:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH] btrfs: fix decompress buffer size
Message-ID: <20130214113845.GH12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360833139-5850-1-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360833139-5850-1-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 06:12:19PM +0900, Kyungsik Lee wrote:
> lzo1x_1_compress() is unnecessarily used for allocating decompress buffer.
> 
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -55,7 +55,7 @@ static struct list_head *lzo_alloc_workspace(void)
>  		return ERR_PTR(-ENOMEM);
>  
>  	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
> -	workspace->buf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
> +	workspace->buf = vmalloc(PAGE_CACHE_SIZE);

Right, PAGE_CACHE_SIZE is enough in size, but then we don't even need
vmalloc.

david
