Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3L1J1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 04:27:12 -0500
Received: from forward9l.mail.yandex.net ([84.201.143.142]:49359 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3L1J1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 04:27:10 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2013 04:27:10 EST
X-Yandex-Uniq: 6aedc66d-c6b8-430d-9223-701d8bb9c393
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Date: Sat, 28 Dec 2013 13:19:48 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] sched, rt: move .switched_from out of the scope of
 CONFIG_SMP
Message-ID: <20131228091948.GA3832@HP-250-G1-Notebook-PC.beeline>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
 <1388144464-28458-2-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388144464-28458-2-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Пт, дек 27, 2013 at 07:41:00 +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> .switched_from shouldn't be initialized in the scope of CONFIG_SMP,
> so this patch is trying to move it out.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  kernel/sched/rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 1c40655..f34d41b 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -2002,9 +2002,9 @@ const struct sched_class rt_sched_class = {
>  	.pre_schedule		= pre_schedule_rt,
>  	.post_schedule		= post_schedule_rt,
>  	.task_woken		= task_woken_rt,
> -	.switched_from		= switched_from_rt,
>  #endif
>  
> +	.switched_from		= switched_from_rt,
>  	.set_curr_task          = set_curr_task_rt,
>  	.task_tick		= task_tick_rt,

This will not be compilable in !SMP mode because the body of switched_from_rt()
is still under CONFIG_SMP define.

Kirill
