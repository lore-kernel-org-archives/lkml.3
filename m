Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab3BTQ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:28:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117Ab3BTQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:28:06 -0500
Date: Wed, 20 Feb 2013 11:27:48 -0500
From: Peter Jones <pjones@redhat.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Matt Fleming <matt.fleming@intel.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: partitions: efi: Typecast sizeof(gpt_header)
Message-ID: <20130220162748.GA32341@fenchurch.internal.datastacks.com>
References: <1361371930-1520-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361371930-1520-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:52:10AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit ef25bb0fa6e2 (block/partitions/efi.c: ensure that the GPT header is
> at least the size of the structure.) , when building for a 32-bit architecture, 
> such as ARM, the following build warning is seen:
> 
> block/partitions/efi.c:324:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Hi Fabio,

I sent and updated version of ef25bb0fa6e2 this morning to fix this
issue.  Thanks for the patch, though.  Andrew, if you'd like you can
just use this instead of replacing my patch with the new one.

Signed-off-by: Peter Jones <pjones@redhat.com>

> 
> Typecast sizeof(gpt_header) to (unsigned long) to avoid such warning on 32-bit 
> systems.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  block/partitions/efi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index a7475e7..62e05cf 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -323,7 +323,7 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>  	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
>  		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
>  			le32_to_cpu((*gpt)->header_size),
> -			sizeof(gpt_header));
> +			(unsigned long)sizeof(gpt_header));
>  		goto fail;
>  	}
>  
> -- 
> 1.7.9.5
> 

-- 
        Peter
