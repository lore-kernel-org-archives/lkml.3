Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960Ab3DJBwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:52:02 -0400
Received: from ozlabs.org ([203.10.76.45]:44894 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762266Ab3DJBwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:52:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: module: using strlcpy and strcpy instead of strncpy
In-Reply-To: <5163814A.2030006@asianux.com>
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com> <5163814A.2030006@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Apr 2013 10:52:52 +0930
Message-ID: <877gkb89hv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
>   namebuf is NUL terminated string.  better always let it ended by '\0'.
>   ownername and module_name(owner) are the same buf len. strcpy is better.
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Would be better to describe the justificaiton for strcpy in
resolve_symbol(), eg.

For resolve_symbol() we just use strcpy: the module_name() is always the
name field of struct module (which is a fixed array), or a literal "kernel".

Cheers,
Rusty.

> ---
>  kernel/module.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 3c2c72d..09aeefd 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1283,7 +1283,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
>  
>  getname:
>  	/* We must make copy under the lock if we failed to get ref. */
> -	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
> +	strcpy(ownername, module_name(owner));
>  unlock:
>  	mutex_unlock(&module_mutex);
>  	return sym;
> @@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
>  	}
>  	/* Make a copy in here where it's safe */
>  	if (ret) {
> -		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
> +		strlcpy(namebuf, ret, KSYM_NAME_LEN);
>  		ret = namebuf;
>  	}
>  	preempt_enable();
> -- 
> 1.7.7.6
