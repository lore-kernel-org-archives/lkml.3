Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3JCBGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 21:06:53 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:54423 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3JCBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 21:06:52 -0400
Message-ID: <1380762910.19256.70.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] percpu_ida: Removing unused arguement from
 alloc_local_tag
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Nick Swenson <nks@daterainc.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Date: Wed, 02 Oct 2013 18:15:10 -0700
In-Reply-To: <1380761745-8605-1-git-send-email-nks@daterainc.com>
References: <1380761745-8605-1-git-send-email-nks@daterainc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 17:55 -0700, Nick Swenson wrote:
> Removing unused struct percpu_ida *pool from arguemnts of
> alloc_local_tag, changed it's one use in idr.c
> 
> Signed-Off-By: Nick Swenson <nks@daterainc.com>
> ---

Nice patch, but the upstream version of percpu_ida lives in
lib/percpu_ida.c, and not lib/idr.c.  :-)

Soooo, modified your patch to use this location instead, and applied
target-pending/for-next.

Thanks!

--nab

>  lib/idr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index 26495e1..86e8f73 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -1254,8 +1254,7 @@ static inline void alloc_global_tags(struct percpu_ida *pool,
>  		  min(pool->nr_free, IDA_PCPU_BATCH_MOVE));
>  }
>  
> -static inline unsigned alloc_local_tag(struct percpu_ida *pool,
> -				       struct percpu_ida_cpu *tags)
> +static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
>  {
>  	int tag = -ENOSPC;
>  
> @@ -1291,7 +1290,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
>  	tags = this_cpu_ptr(pool->tag_cpu);
>  
>  	/* Fastpath */
> -	tag = alloc_local_tag(pool, tags);
> +	tag = alloc_local_tag(tags);
>  	if (likely(tag >= 0)) {
>  		local_irq_restore(flags);
>  		return tag;


