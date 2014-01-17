Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaAQL7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:59:19 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60204 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAQL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:59:12 -0500
X-Nat-Received: from [202.181.97.72]:56006 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389959943.347
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.13-rc5] module: Add missing newline in printk call.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312231603.IGB09833.HLJtFMOOFSFQVO@I-love.SAKURA.ne.jp>
In-Reply-To: <201312231603.IGB09833.HLJtFMOOFSFQVO@I-love.SAKURA.ne.jp>
Message-Id: <201401172058.DHJ34830.OFFSOLVJHOMtFQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 17 Jan 2014 20:58:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17012014 #7344181, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, would you pick up this patch?

This message was added in 3.13-rc1. Thus, should be fixed in 3.13.

Tetsuo Handa wrote:
> From cc90e27d5cda227e7a0cbeb5de3cc1cbb1595dfa Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 23 Dec 2013 15:52:42 +0900
> Subject: [PATCH] module: Add missing newline in printk call.
> 
> Add missing \n and also follow commit bddb12b3 "kernel/module.c: use pr_foo()".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  kernel/module.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index f5a3b1e..d24fcf2 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -815,10 +815,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  		return -EFAULT;
>  	name[MODULE_NAME_LEN-1] = '\0';
>  
> -	if (!(flags & O_NONBLOCK)) {
> -		printk(KERN_WARNING
> -		       "waiting module removal not supported: please upgrade");
> -	}
> +	if (!(flags & O_NONBLOCK))
> +		pr_warn("waiting module removal not supported: please upgrade\n");
>  
>  	if (mutex_lock_interruptible(&module_mutex) != 0)
>  		return -EINTR;
> -- 
> 1.7.1
> 
