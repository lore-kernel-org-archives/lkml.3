Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaEFXdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:33:37 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55888 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaEFXdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140504011549.04805208@spike>
References: <20140504011549.04805208@spike>
Date: Tue, 6 May 2014 16:33:35 -0700
Message-ID: <CAMP5XgfRGj+h+z2Zv=+FVxOTyZSmhAqVC581RaxLRZLD9uEjtw@mail.gmail.com>
Subject: Re: [PATCH] staging: binder: fix usage of uninit scalar in binder_transaction()
From: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        John Stultz <john.stultz@linaro.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 3, 2014 at 4:15 PM, Christian Engelmayer <cengelma@gmx.at> wrote:
> Fix the error path when a cookie mismatch is detected. In that case the
> function jumps to the exit label without setting the uninitialized, local
> variable 'return_error'. Detected by Coverity - CID 201453.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/android/binder.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 1f5e249..ca1b0e3 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -1529,6 +1529,7 @@ static void binder_transaction(struct binder_proc *proc,
>                                         proc->pid, thread->pid,
>                                         (u64)fp->binder, node->debug_id,
>                                         (u64)fp->cookie, (u64)node->cookie);
> +                               return_error = BR_FAILED_REPLY;
>                                 goto err_binder_get_ref_for_node_failed;
>                         }
>                         ref = binder_get_ref_for_node(target_proc, node);
> --
> 1.9.1

Acked-by: Arve Hjønnevåg <arve@android.com>
