Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaKYRy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:54:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35071 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYRy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:54:27 -0500
Message-ID: <5474C255.6020703@arm.com>
Date: Tue, 25 Nov 2014 17:54:29 +0000
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched/deadline: fix pull if dl task who's prio changed
 is not on queue
References: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com> <1416386103-90800-2-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1416386103-90800-2-git-send-email-wanpeng.li@linux.intel.com>
X-OriginalArrivalTime: 25 Nov 2014 17:54:25.0089 (UTC) FILETIME=[D9A0B310:01D008D8]
X-MC-Unique: 114112517542501301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19/11/14 08:35, Wanpeng Li wrote:
> Dl task who is not on queue and it is also the curr task simultaneously 
> can not happen. In addition, pull since the priority of a not on queue 
> dl task doesn't make any sense.
> 
> This patch fix it by don't pull if dl task who's prio changed is not on 
> queue.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/deadline.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index b9e44ae..4eaf55c 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1678,7 +1678,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>  static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>  			    int oldprio)
>  {
> -	if (task_on_rq_queued(p) || rq->curr == p) {
> +	if (!task_on_rq_queued(p))
> +		return;
> +
> +	if (rq->curr == p) {

Yeah. I already posted a patches for this, that I forgot to properly
post again :/. I'll do it soon.

Thanks,

- Juri

>  #ifdef CONFIG_SMP
>  		/*
>  		 * This might be too much, but unfortunately
> 

