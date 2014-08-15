Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaHOTYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:24:31 -0400
Received: from ozlabs.org ([103.22.144.67]:53007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaHOTY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:24:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: kpark3469@gmail.com, akpm@linux-foundation.org
Cc: keun-o.park@windriver.com, hpa@zytor.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com, oleg@redhat.com,
        prarit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
In-Reply-To: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 16 Aug 2014 04:04:13 +0930
Message-ID: <87lhqp8uvu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kpark3469@gmail.com writes:
> From: Sahara <keun-o.park@windriver.com>
>
> Although there are many obs_kernel_param and its names are
> earlyprintk and also EARLY_PRINTK is also enabled, we could not
> see the early_printk output properly until now. This patch
> considers earlycon as well as earlyprintk.

Hmm, the initial "earlycon" hack slipped in when I wasn't looking.
I don't think we should extend it.

Why not make the thing(s) you want early_param()s?

Cheers,
Rusty.

> --- a/init/main.c
> +++ b/init/main.c
> @@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char *val, const char *unused)
>  	for (p = __setup_start; p < __setup_end; p++) {
>  		if ((p->early && parameq(param, p->str)) ||
>  		    (strcmp(param, "console") == 0 &&
> -		     strcmp(p->str, "earlycon") == 0)
> +		     ((strcmp(p->str, "earlycon") == 0) ||
> +		     (strcmp(p->str, "earlyprintk") == 0)))
>  		) {
>  			if (p->setup_func(val) != 0)
>  				pr_warn("Malformed early option '%s'\n", param);
> -- 
> 1.7.9.5
