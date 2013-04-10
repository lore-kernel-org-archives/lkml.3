Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab3DJKfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:35:32 -0400
Received: from ozlabs.org ([203.10.76.45]:59382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936832Ab3DJKf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:35:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: parameters checking, for EXPORT_SYMBOL_GPL functions
In-Reply-To: <5163AE9A.8060505@asianux.com>
References: <5163AE9A.8060505@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Apr 2013 16:27:41 +0930
Message-ID: <871uai7tzu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
>   for EXPORT_SYMBOL_GPL functions, necessary to check their parameters.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Why?

If someone misuses these functions, they crash and thus indicate that
the caller shouldn't do that.

Or is someone already doing this?

Confused,
Rusty.

> ---
>  kernel/kallsyms.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 2169fee..4ba57a9 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -175,6 +175,9 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	unsigned long i;
>  	unsigned int off;
>  
> +	if (!name || !name[0])
> +		return 0;
> +
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
>  		off = kallsyms_expand_symbol(off, namebuf);
>  
> @@ -194,6 +197,9 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  	unsigned int off;
>  	int ret;
>  
> +	if (!fn)
> +		return -EINVAL;
> +
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
>  		off = kallsyms_expand_symbol(off, namebuf);
>  		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
> @@ -382,6 +388,9 @@ static int __sprint_symbol(char *buffer, unsigned long address,
>   */
>  int sprint_symbol(char *buffer, unsigned long address)
>  {
> +	if (!buffer)
> +		return 0;
> +
>  	return __sprint_symbol(buffer, address, 0, 1);
>  }
>  EXPORT_SYMBOL_GPL(sprint_symbol);
> @@ -399,6 +408,9 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
>   */
>  int sprint_symbol_no_offset(char *buffer, unsigned long address)
>  {
> +	if (!buffer)
> +		return 0;
> +
>  	return __sprint_symbol(buffer, address, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(sprint_symbol_no_offset);
> -- 
> 1.7.7.6
