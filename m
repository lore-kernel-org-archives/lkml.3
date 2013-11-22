Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3KVUQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:16:52 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46245 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KVUQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131122191820.GA16936@redhat.com>
References: <20131122191803.GA16919@redhat.com> <20131122191820.GA16936@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 22 Nov 2013 12:16:29 -0800
X-Google-Sender-Auth: p5mCfNKhnBgaadRS-bso_ItZm6c
Message-ID: <CANMivWZW-2dnm3b0Su9coEK+QfZ-kpH6G=9HgeJWM65AdhORyg@mail.gmail.com>
Subject: Re: [PATCH 2/3] k_getrusage() can use while_each_thread()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Change k_getrusage() to use while_each_thread(), no changes in
> the compiled code.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>

> ---
>  kernel/sys.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 1d9a218..70d56d6 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1572,8 +1572,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>                         t = p;
>                         do {
>                                 accumulate_thread_rusage(t, r);
> -                               t = next_thread(t);
> -                       } while (t != p);
> +                       } while_each_thread(p, t);
>                         break;
>
>                 default:
> --
> 1.5.5.1
>
