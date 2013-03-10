Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3CJOK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 10:10:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:47066 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3CJOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 10:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <1362920779-25925-1-git-send-email-alex.grad@gmail.com>
References: <1362920779-25925-1-git-send-email-alex.grad@gmail.com>
Date: Sun, 10 Mar 2013 16:10:56 +0200
X-Google-Sender-Auth: fPUoRqoFp-UuSHc9Xv6ycTKQgPo
Message-ID: <CAOJsxLGD1fXsGMCQbP8aAMDsRiwPD2hHcfWfupO4jy5=JCM=NA@mail.gmail.com>
Subject: Re: [PATCH] kgdb: Removed kmalloc returned value cast
From: Pekka Enberg <penberg@kernel.org>
To: Alex Grad <alex.grad@gmail.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, mikey@neuling.org,
        tiejun.chen@windriver.com, jason.wessel@windriver.com,
        fr@canb.auug.org.au, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 3:06 PM, Alex Grad <alex.grad@gmail.com> wrote:
> Signed-off-by: Alex Grad <alex.grad@gmail.com>
> ---
>  arch/powerpc/kernel/kgdb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 5ca82cd..c1eef24 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -159,7 +159,7 @@ static int kgdb_singlestep(struct pt_regs *regs)
>         if (user_mode(regs))
>                 return 0;
>
> -       backup_current_thread_info = (struct thread_info *)kmalloc(sizeof(struct thread_info), GFP_KERNEL);
> +       backup_current_thread_info = kmalloc(sizeof(struct thread_info), GFP_KERNEL);

Looks good to me.

There's two additional problems in the kgdb_singlestep() function: it
doesn't check if the kmalloc() call fails nor does it kfree() the
allocated memory.

                        Pekka
