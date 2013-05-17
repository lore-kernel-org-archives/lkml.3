Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3EQP7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:59:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab3EQP7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:59:17 -0400
Date: Fri, 17 May 2013 08:59:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Tikhomirov <snorcht@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 1/1] posix-timers: Show clock ID in proc file
Message-ID: <20130517155916.GA24976@kroah.com>
References: <1368742323-46949-1-git-send-email-snorcht@gmail.com>
 <1368742323-46949-2-git-send-email-snorcht@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368742323-46949-2-git-send-email-snorcht@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:12:03AM +0400, Pavel Tikhomirov wrote:
> Expand information about posix-timers in /proc/<pid>/timers by adding
> info about clock, with which the timer was created. I.e. in the forth
> line of timer info after "notify:" line go "ClockID: <clock_id>".
> 
> Signed-off-by: Pavel Tikhomirov <snorcht@gmail.com>
> ---
>  fs/proc/base.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 2dad4a9..8a38eef 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2079,6 +2079,7 @@ static int show_timer(struct seq_file *m, void *v)
>  		nstr[notify & ~SIGEV_THREAD_ID],
>  		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
>  		pid_nr_ns(timer->it_pid, tp->ns));
> +	seq_printf(m, "ClockID: %d\n", timer->it_clock);

What userspace tool just broke by adding a new field to this file?

thanks,

greg k-h
