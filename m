Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaCXTFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:05:48 -0400
Received: from mail.efficios.com ([78.47.125.74]:51571 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbaCXTFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:05:46 -0400
Date: Mon, 24 Mar 2014 19:05:50 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
Cc: rostedt@goodmis.org, keun-o park <keun-o.park@windriver.com>,
        linux-kernel@vger.kernel.org
Message-ID: <1254335726.9892.1395687950937.JavaMail.zimbra@efficios.com>
In-Reply-To: <1395601748-12313-1-git-send-email-monamagarwal123@gmail.com>
References: <1395601748-12313-1-git-send-email-monamagarwal123@gmail.com>
Subject: Re: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in tracepoint.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF28 (Linux)/8.0.5_GA_5839)
Thread-Topic: kernel: Use RCU_INIT_POINTER(x, NULL) in tracepoint.c
Thread-Index: GouAMI1WWrsuwy7MLjdpXPezBcNQWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Monam Agarwal" <monamagarwal123@gmail.com>
> To: "mathieu desnoyers" <mathieu.desnoyers@efficios.com>, rostedt@goodmis.org, "keun-o park"
> <keun-o.park@windriver.com>, linux-kernel@vger.kernel.org
> Sent: Sunday, March 23, 2014 3:09:08 PM
> Subject: [PATCH] kernel: Use RCU_INIT_POINTER(x, NULL) in tracepoint.c
> 
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
> NULL)
> 
> The rcu_assign_pointer() ensures that the initialization of a structure
> is carried out before storing a pointer to that structure.
> And in the case of the NULL pointer, there is no structure to initialize.
> So, rcu_assign_pointer(p, NULL) can be safely converted to
> RCU_INIT_POINTER(p, NULL)

This change makes sense. However, it would conflict with the changes
I'm proposing for 3.15, which are making this patch obsolete. This would
cause merging headaches for Steven. So it's his call.

Thanks,

Mathieu

> 
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
>  kernel/tracepoint.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 031cc56..72dfa96 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -291,7 +291,7 @@ static void disable_tracepoint(struct tracepoint *elem)
>  
>  	if (static_key_enabled(&elem->key))
>  		static_key_slow_dec(&elem->key);
> -	rcu_assign_pointer(elem->funcs, NULL);
> +	RCU_INIT_POINTER(elem->funcs, NULL);
>  }
>  
>  /**
> --
> 1.7.9.5
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
