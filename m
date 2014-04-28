Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750749AbaD1IsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaD1IsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:48:14 -0400
Message-ID: <535E15C2.8080203@redhat.com>
Date: Mon, 28 Apr 2014 09:48:02 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/gfs2/lops.c: replace 0 by NULL for pointers
References: <20140426205723.35360f20c80bd33d96c4863d@skynet.be>
In-Reply-To: <20140426205723.35360f20c80bd33d96c4863d@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/04/14 19:57, Fabian Frederick wrote:
> Sparse warning: fs/gfs2/lops.c:78:29:
> "warning: Using plain integer as NULL pointer"
>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   fs/gfs2/lops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Now in the GFS2 -nmw tree. Thanks,

Steve.

> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index a294d8d..2c1ae86 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -75,7 +75,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
>   	unsigned int index = bd->bd_bh->b_blocknr - gl->gl_name.ln_number;
>   	struct gfs2_bitmap *bi = rgd->rd_bits + index;
>   
> -	if (bi->bi_clone == 0)
> +	if (bi->bi_clone == NULL)
>   		return;
>   	if (sdp->sd_args.ar_discard)
>   		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi, 1, NULL);

