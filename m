Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3DKICU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3DKICQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:02:16 -0400
Subject: Re: [PATCH 3.8-stable] GFS2: return error if malloc failed in
 gfs2_rs_alloc()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>
In-Reply-To: <000501ce3658$b3022fd0$19068f70$%choi@samsung.com>
References: <000501ce3658$b3022fd0$19068f70$%choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 11 Apr 2013 08:59:57 +0100
Message-ID: <1365667197.2701.13.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-04-11 at 11:03 +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?
> 
Yes, again looks like a good plan,

Steve.

> ------------------
> 
> From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"
> 
> commit 441362d06be349430d06e37286adce4b90e6ce96 upstream
> 
> The error code in gfs2_rs_alloc() is set to ENOMEM when error
> but never be used, instead, gfs2_rs_alloc() always return 0.
> Fix to return 'error'.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  fs/gfs2/rgrp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index b7eff07..9afba3d6 100644
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


