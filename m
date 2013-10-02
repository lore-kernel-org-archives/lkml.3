Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3JBFP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:15:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53611 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3JBFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:15:55 -0400
Message-ID: <524BAC04.30501@gmail.com>
Date: Wed, 02 Oct 2013 15:15:48 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlldSBSaMOpYXVtZQ==?= <mathieu@codingrhemes.com>
CC: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging : android: binder.c: Prefer seq_puts to seq_printf
References: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
In-Reply-To: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/13 11:57, Mathieu Rhéaume wrote:
> This patch changes seq_printf for seq_puts in binder.c.
> It fixes the warnings emitted by checkpatch.pl.
> 
> Signed-off-by: Mathieu Rhéaume <mathieu@codingrhemes.com>
> ---
>  drivers/staging/android/binder.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 09edebb..f3d4a1f 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -3272,7 +3272,7 @@ binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
>  static void print_binder_transaction(struct seq_file *m, const char *prefix,
>  				     struct binder_transaction *t)
>  {
> -	seq_printf(m,
> +	seq_puts(m,
>  		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
>  		   prefix, t->debug_id, t,
>  		   t->from ? t->from->proc->pid : 0,

Umm, this won't compile. seq_puts() is defined as:

  int seq_puts(struct seq_file *m, const char *s);

checkpatch.pl does indeed complain about uses of seq_printf() in
drivers/staging/android/binder.c which are passing formatted strings. At
a quick glance it looks like checkpatch.pl is only checking for the
format string on the same line as seq_printf(), so this files ugly
coding style confuses the check. Joe?

Anyway, please don't blindly change things in the kernel without at
least compile testing them.

~Ryan

