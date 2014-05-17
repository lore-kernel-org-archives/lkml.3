Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401AbaEQR4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:56:01 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44294 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030262AbaEQRz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:55:59 -0400
Message-ID: <5377A2AB.4020804@colorfullife.com>
Date: Sat, 17 May 2014 19:55:55 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ipc,msg: use current->state helpers
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-2-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400012857-11733-2-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> Call __set_current_state() instead of assigning
> the new state directly.
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullif.com>

> ---
>   ipc/msg.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 7ed1ef3..5a8489b 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -227,7 +227,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
>   static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
>   {
>   	mss->tsk = current;
> -	current->state = TASK_INTERRUPTIBLE;
> +	__set_current_state(TASK_INTERRUPTIBLE);
>   	list_add_tail(&mss->list, &msq->q_senders);
>   }
>   
> @@ -976,7 +976,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
>   		else
>   			msr_d.r_maxsize = bufsz;
>   		msr_d.r_msg = ERR_PTR(-EAGAIN);
> -		current->state = TASK_INTERRUPTIBLE;
> +		__set_current_state(TASK_INTERRUPTIBLE);
>   
>   		ipc_unlock_object(&msq->q_perm);
>   		rcu_read_unlock();

