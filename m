Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3KVUQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:16:19 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60315 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <20131122191818.GA16933@redhat.com>
References: <20131122191803.GA16919@redhat.com> <20131122191818.GA16933@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 22 Nov 2013 12:15:57 -0800
X-Google-Sender-Auth: vdUEEFFutJpUdPx6goZ-lkLmdc8
Message-ID: <CANMivWaUUH-gncZxA6RjcavPx-iFc8hDHxErzgVdAzTnnL3r+A@mail.gmail.com>
Subject: Re: [PATCH 1/3] proc: change do_task_stat() to use while_each_thread()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> do_task_stat() can use while_each_thread(), no changes in
> the compiled code.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>

> ---
>  fs/proc/array.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index c995807..c59e74f 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -442,8 +442,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>                                 min_flt += t->min_flt;
>                                 maj_flt += t->maj_flt;
>                                 gtime += task_gtime(t);
> -                               t = next_thread(t);
> -                       } while (t != task);
> +                       } while_each_thread(task, t);
>
>                         min_flt += sig->min_flt;
>                         maj_flt += sig->maj_flt;
> --
> 1.5.5.1
>
