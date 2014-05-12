Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbaELUn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:43:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaELUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:43:27 -0400
Date: Mon, 12 May 2014 13:43:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/2] FS/CACHEFILES: convert printk to pr_foo()
Message-Id: <20140512134325.e16b48e91cca8ca1e3f9f63b@linux-foundation.org>
In-Reply-To: <20140512200445.edee2954e66a1d2ec4cf31ca@skynet.be>
References: <20140512200445.edee2954e66a1d2ec4cf31ca@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 20:04:45 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> 
> --- a/fs/cachefiles/bind.c
> +++ b/fs/cachefiles/bind.c
> @@ -228,9 +228,8 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
>  	set_bit(CACHEFILES_READY, &cache->flags);
>  	dput(root);
>  
> -	printk(KERN_INFO "CacheFiles:"
> -	       " File cache on %s registered\n",
> -	       cache->cache.identifier);
> +	pr_info("CacheFiles: File cache on %s registered\n",
> +		cache->cache.identifier);

Why are we using "CacheFiles: " everywhere?  Can't this be done via pr_fmt()?

