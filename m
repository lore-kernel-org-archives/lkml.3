Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab3DGVPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:15:54 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:61237 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762413Ab3DGVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:15:51 -0400
Date: Sun, 7 Apr 2013 14:15:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kent Overstreet <koverstreet@google.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include
 <linux/prefetch.h>
In-Reply-To: <20130327195050.GB22232@google.com>
Message-ID: <alpine.DEB.2.02.1304071415220.3441@chino.kir.corp.google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org> <20130327182150.GB25906@google.com> <51533A2E.2000501@infradead.org> <20130327195050.GB22232@google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Kent Overstreet wrote:

> Nope - looks like __WARN() doesn't exist if CONFIG_BUG=n, whoops.
> 
> Adding this to the queue:
> 
> commit 796c213186b850b3e6e8d5fd5799b0fd74721ea3
> Author: Kent Overstreet <koverstreet@google.com>
> Date:   Wed Mar 27 12:47:45 2013 -0700
> 
>     bcache: Use WARN_ONCE() instead of __WARN()
>     
>     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index d4f2164..cb4578a 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -883,7 +883,7 @@ struct bkey *bch_btree_iter_next(struct btree_iter *iter)
>  		iter->data->k = bkey_next(iter->data->k);
>  
>  		if (iter->data->k > iter->data->end) {
> -			__WARN();
> +			WARN_ONCE(1, "bset was corrupt!\n");
>  			iter->data->k = iter->data->end;
>  		}
>  

This problem still persists in linux-next as of today, how is this fix 
being pushed?
