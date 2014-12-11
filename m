Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399AbaLKR34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:29:56 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60497 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbaLKR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <20141211162228.GA10717@rim.emol.mesa.nl>
References: <20141211162228.GA10717@rim.emol.mesa.nl>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 11 Dec 2014 09:29:33 -0800
Message-ID: <CALCETrU4t1PGodreaunDB1p7FvqhyG5XP=7D+miULn5hXKdTgQ@mail.gmail.com>
Subject: Re: [PATCH] Make /proc/<pid>/io world readable
To: marcel@mesa.nl
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Djalal Harouni <tixxdz@opendz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 8:22 AM, Marcel Mol <marcel@mesa.nl> wrote:
> /proc/<pid>/io is only readable by the pid owner, while files
> like stat, statm and status are world readable.
> I see no reason why io statistics should be hidden.
> This patch makes io also world readable so process io counts
> can be analysed without root permissions.

I'd really rather go the other direction and leak less information to
the world by default.

If we wanted to add a general control to let admins set permissions
for proc files for new processes, that could be useful.  Then admins
could set this.

--Andy

>
> Signed-off-by: Marcel Mol <marcel@mesa.nl>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 772efa4..7bd8dbe 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2563,7 +2563,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>         REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
>  #endif
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -       ONE("io",       S_IRUSR, proc_tgid_io_accounting),
> +       ONE("io",       S_IRUGO, proc_tgid_io_accounting),
>  #endif
>  #ifdef CONFIG_HARDWALL
>         ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> @@ -2904,7 +2904,7 @@ static const struct pid_entry tid_base_stuff[] = {
>         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
>  #endif
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -       ONE("io",       S_IRUSR, proc_tid_io_accounting),
> +       ONE("io",       S_IRUGO, proc_tid_io_accounting),
>  #endif
>  #ifdef CONFIG_HARDWALL
>         ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> --
> 1.9.3
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
