Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3EMC6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:58:13 -0400
Received: from ozlabs.org ([203.10.76.45]:59091 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3EMC50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:57:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: majianpeng <majianpeng@gmail.com>
Cc: lizefan@huawei.com, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.
In-Reply-To: <518DAA1A.3010407@gmail.com>
References: <518DAA1A.3010407@gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 13 May 2013 11:54:09 +0930
Message-ID: <87bo8f39di.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

majianpeng <majianpeng@gmail.com> writes:

> In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
> It will cause kmemleak to misjudge because when loading module it did
> not add '.ref.data' into kmemleak-scan-area.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  kernel/module.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Catalin?

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

> diff --git a/kernel/module.c b/kernel/module.c
> index b049939..dafe2ea 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2434,7 +2434,8 @@ static void kmemleak_load_module(const struct module *mod,
>                 const char *name = info->secstrings + info->sechdrs[i].sh_name;
>                 if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
>                         continue;
> -               if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
> +               if (!strstarts(name, ".data") && !strstarts(name, ".bss") &&
> +                       !strstarts(name, ".ref.data"))
>                         continue;
>  
>                 kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
> -- 
> 1.7.10.4
>
>>From 9adf5b9aae7ceb97828042d0ae8fe9fb688bc691 Mon Sep 17 00:00:00 2001
> From: Jianpeng Ma <majianpeng@gmail.com>
> Date: Sat, 11 May 2013 10:04:14 +0800
> Subject: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.
>
> In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
> It will cause kmemleak to misjudge because when loading module it did
> not add '.ref.data' into kmemleak-scan-area.
>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  kernel/module.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index b049939..dafe2ea 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2434,7 +2434,8 @@ static void kmemleak_load_module(const struct module *mod,
>  		const char *name = info->secstrings + info->sechdrs[i].sh_name;
>  		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
>  			continue;
> -		if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
> +		if (!strstarts(name, ".data") && !strstarts(name, ".bss") && 
> +			!strstarts(name, ".ref.data"))
>  			continue;
>  
>  		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
> -- 
> 1.7.10.4
