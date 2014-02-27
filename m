Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaB0NhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:37:04 -0500
Received: from mail.efficios.com ([78.47.125.74]:46863 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaB0NhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:37:00 -0500
Date: Thu, 27 Feb 2014 13:37:02 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sahara <keun-o.park@windriver.com>, josh@joshtriplett.org
Message-ID: <320460510.31556.1393508222940.JavaMail.zimbra@efficios.com>
In-Reply-To: <146d7ec7dd9959f01020fb5543699966b50484ef.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <146d7ec7dd9959f01020fb5543699966b50484ef.1393493277.git.rashika.kheria@gmail.com>
Subject: Re: [PATCH 37/46] kernel: Include appropriate header file in
 tracepoint.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: kernel: Include appropriate header file in tracepoint.c
Thread-Index: KDUKvEVMPmNHhFUvgrP6EkOE1+9SUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Rashika Kheria" <rashika.kheria@gmail.com>
> To: linux-kernel@vger.kernel.org
> Cc: "Rashika Kheria" <rashika.kheria@gmail.com>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Sasha Levin"
> <sasha.levin@oracle.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, "Sahara" <keun-o.park@windriver.com>, josh@joshtriplett.org
> Sent: Thursday, February 27, 2014 7:22:05 AM
> Subject: [PATCH 37/46] kernel: Include appropriate header file in tracepoint.c
> 
> Include appropriate header file include/trace/events/syscalls.h in
> kernel/tracepoint.c because it has prototype definition of functions
> defined in kernel/tracepoint.c.
> 
> This eliminates the following warning in kernel/tracepoint.c:
> kernel/tracepoint.c:738:6: warning: no previous prototype for
> ‘syscall_regfunc’ [-Wmissing-prototypes]
> kernel/tracepoint.c:755:6: warning: no previous prototype for
> ‘syscall_unregfunc’ [-Wmissing-prototypes]

Tracepoints are the infrastructure on which trace events are build. tracepoint.c
should not include a trace event header: this is an abstraction inversion.

I propose we move the

extern void syscall_regfunc(void);
extern void syscall_unregfunc(void);

declarations to include/linux/tracepoint.h instead.

Thanks,

Mathieu

> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/tracepoint.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0e26255..124d733 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -26,6 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/static_key.h>
> +#include <trace/events/syscalls.h>
>  
>  extern struct tracepoint * const __start___tracepoints_ptrs[];
>  extern struct tracepoint * const __stop___tracepoints_ptrs[];
> --
> 1.7.9.5
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
