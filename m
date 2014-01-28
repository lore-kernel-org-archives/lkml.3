Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaA1WIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:08:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaA1WIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:08:41 -0500
Date: Tue, 28 Jan 2014 14:08:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
Message-Id: <20140128140839.733d94150b99aaf7ac08bf96@linux-foundation.org>
In-Reply-To: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 14:04:25 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> In original bootmem wrapper for memblock, we have limit checking.
> 
> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
> 
> ...
>
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -1077,6 +1077,9 @@ static void * __init memblock_virt_alloc
>  	if (!align)
>  		align = SMP_CACHE_BYTES;
>  
> +	if (max_addr > memblock.current_limit)
> +		max_addr = memblock.current_limit;
> +
>  again:
>  	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
>  					    nid);

Thanks.

Kevin, Olof and Konrad (at least) have been hitting this.  It would be
great to get some tested-by's, please?

