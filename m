Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbaHYRnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbaHYRnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:43:40 -0400
Date: Mon, 25 Aug 2014 13:42:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] kexec: Simplify conditional
Message-ID: <20140825174244.GE14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
 <5a3bbdeb26cd8891f2b9de1ce05dbacfc282f7d1.1408731991.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a3bbdeb26cd8891f2b9de1ce05dbacfc282f7d1.1408731991.git.geoff@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> Simplify the code around one of the conditionals in the kexec_load
> syscall routine.
> 
> The original code was confusing with a redundant check on KEXEC_ON_CRASH
> and comments outside of the conditional block.  This change switches the
> order of the conditional check, and cleans up the comments for the
> conditional.  There is no functional change to the code.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

This is simple reorganization.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  kernel/kexec.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 0b49a0a..d04b56e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1282,19 +1282,22 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  	if (nr_segments > 0) {
>  		unsigned long i;
>  
> -		/* Loading another kernel to reboot into */
> -		if ((flags & KEXEC_ON_CRASH) == 0)
> -			result = kimage_alloc_init(&image, entry, nr_segments,
> -						   segments, flags);
> -		/* Loading another kernel to switch to if this one crashes */
> -		else if (flags & KEXEC_ON_CRASH) {
> -			/* Free any current crash dump kernel before
> +		if (flags & KEXEC_ON_CRASH) {
> +			/*
> +			 * Loading another kernel to switch to if this one
> +			 * crashes.  Free any current crash dump kernel before
>  			 * we corrupt it.
>  			 */
> +
>  			kimage_free(xchg(&kexec_crash_image, NULL));
>  			result = kimage_alloc_init(&image, entry, nr_segments,
>  						   segments, flags);
>  			crash_map_reserved_pages();
> +		} else {
> +			/* Loading another kernel to reboot into. */
> +
> +			result = kimage_alloc_init(&image, entry, nr_segments,
> +						   segments, flags);
>  		}
>  		if (result)
>  			goto out;
> -- 
> 1.9.1
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
