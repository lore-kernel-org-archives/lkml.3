Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbaCSCQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:16:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:5377 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757804AbaCSCQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:16:20 -0400
Date: Tue, 18 Mar 2014 22:16:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 3/3] sched: Use clamp() and clamp_val() to make it more
 readable.
Message-ID: <20140318221618.38da4688@gandalf.local.home>
In-Reply-To: <08e669fea4242209aa625237214410c6bbf67dba.1394619587.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
	<08e669fea4242209aa625237214410c6bbf67dba.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 18:26:44 +0800
Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> As Kees suggested, I use clamp() function to replace the if and
> else branch, making it more readable and modular.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  kernel/sched/core.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 259ab85..85f4231 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3068,17 +3068,10 @@ SYSCALL_DEFINE1(nice, int, increment)
>  	 * We don't have to worry. Conceptually one call occurs first
>  	 * and we have a single winner.
>  	 */
> -	if (increment < -NICE_WIDTH)
> -		increment = -NICE_WIDTH;
> -	if (increment > NICE_WIDTH)
> -		increment = NICE_WIDTH;
> -

Patch 2 and 3 need to be merged into a single patch.

-- Steve

> +	increment = clamp(increment, -NICE_WIDTH, NICE_WIDTH);
>  	nice = task_nice(current) + increment;
> -	if (nice < MIN_NICE)
> -		nice = MIN_NICE;
> -	if (nice > MAX_NICE)
> -		nice = MAX_NICE;
>  
> +	nice = clamp_val(nice, MIN_NICE, MAX_NICE);
>  	if (increment < 0 && !can_nice(current, nice))
>  		return -EPERM;
>  

