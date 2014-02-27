Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaB0NkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:40:06 -0500
Received: from mail.efficios.com ([78.47.125.74]:46886 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaB0NkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:40:04 -0500
Date: Thu, 27 Feb 2014 13:40:06 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sahara <keun-o.park@windriver.com>, josh@joshtriplett.org
Message-ID: <490713489.31563.1393508406922.JavaMail.zimbra@efficios.com>
In-Reply-To: <e3451542f23840c5047daf8ac1b5a74cb510f756.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <e3451542f23840c5047daf8ac1b5a74cb510f756.1393493277.git.rashika.kheria@gmail.com>
Subject: Re: [PATCH 36/46] kernel: Mark functions as static in
 kernel/tracepoint.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: kernel: Mark functions as static in kernel/tracepoint.c
Thread-Index: 0tgWX2yHM0xgOk2in53c79kc2NTOSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Rashika Kheria" <rashika.kheria@gmail.com>
> To: linux-kernel@vger.kernel.org
> Cc: "Rashika Kheria" <rashika.kheria@gmail.com>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Sasha Levin"
> <sasha.levin@oracle.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, "Sahara" <keun-o.park@windriver.com>, josh@joshtriplett.org
> Sent: Thursday, February 27, 2014 7:20:47 AM
> Subject: [PATCH 36/46] kernel: Mark functions as static in kernel/tracepoint.c
> 
> Mark functions as static in kernel/tracepoint.c because they are not
> used outside this file.
> 
> This eliminates the following warning in kernel/tracepoint.c:
> kernel/tracepoint.c:326:6: warning: no previous prototype for
> ‘module_update_tracepoints’ [-Wmissing-prototypes]
> kernel/tracepoint.c:702:5: warning: no previous prototype for
> ‘tracepoint_module_notify’ [-Wmissing-prototypes]

Yes, this needs to be fixed. However, I recommend to simply queue
this cleanup for 3.15 (no -stable backport), as it is not fixing
anything critical.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/tracepoint.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 29f2654..0e26255 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -323,7 +323,7 @@ static void tracepoint_update_probe_range(struct
> tracepoint * const *begin,
>  }
>  
>  #ifdef CONFIG_MODULES
> -void module_update_tracepoints(void)
> +static void module_update_tracepoints(void)
>  {
>  	struct tp_module *tp_mod;
>  
> @@ -332,7 +332,7 @@ void module_update_tracepoints(void)
>  			tp_mod->tracepoints_ptrs + tp_mod->num_tracepoints);
>  }
>  #else /* CONFIG_MODULES */
> -void module_update_tracepoints(void)
> +static void module_update_tracepoints(void)
>  {
>  }
>  #endif /* CONFIG_MODULES */
> @@ -699,7 +699,7 @@ static int tracepoint_module_going(struct module *mod)
>  	return 0;
>  }
>  
> -int tracepoint_module_notify(struct notifier_block *self,
> +static int tracepoint_module_notify(struct notifier_block *self,
>  			     unsigned long val, void *data)
>  {
>  	struct module *mod = data;
> --
> 1.7.9.5
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
