Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3CKQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3CKQLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:11:17 -0400
Subject: Re: [PATCH] GFS2: return error if malloc failed in gfs2_rs_alloc()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd9eg02c+HiLN9AGNDYUCx1qey7sSr6DoR6tJnp20eAvcw@mail.gmail.com>
References: <CAPgLHd9eg02c+HiLN9AGNDYUCx1qey7sSr6DoR6tJnp20eAvcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Mar 2013 16:09:23 +0000
Message-ID: <1363018163.2698.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 -nmw tree. Thanks,

Steve.

On Mon, 2013-03-11 at 23:01 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The error code in gfs2_rs_alloc() is set to ENOMEM when error
> but never be used, instead, gfs2_rs_alloc() always return 0.
> Fix to return 'error'.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/gfs2/rgrp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index 9d16a6f..b850198 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -576,7 +576,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
>  	RB_CLEAR_NODE(&ip->i_res->rs_node);
>  out:
>  	up_write(&ip->i_rw_mutex);
> -	return 0;
> +	return error;
>  }
>  
>  static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
> 
> 


