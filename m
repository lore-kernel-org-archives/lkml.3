Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3AODIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:08:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3AODIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:08:44 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nKwdevkgNS0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=L4JvR7MU6hkA:10 a=W2pEGsi_yxZVVERSeuAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358219321.4068.9.camel@gandalf.local.home>
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 14 Jan 2013 22:08:41 -0500
In-Reply-To: <20130114194956.GB3384@linux.vnet.ibm.com>
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au>
	 <50EB252C.4010005@infradead.org> <20130107221627.GZ2525@linux.vnet.ibm.com>
	 <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
	 <1357600327.5190.13.camel@gandalf.local.home>
	 <1357605379.5190.15.camel@gandalf.local.home>
	 <20130108035348.GF2525@linux.vnet.ibm.com> <50F43612.8080600@infradead.org>
	 <20130114173208.GY3384@linux.vnet.ibm.com> <50F45321.50808@infradead.org>
	 <20130114194956.GB3384@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 11:49 -0800, Paul E. McKenney wrote:

> diff --git a/kernel/rcu.h b/kernel/rcu.h
> index 7f8e759..b5d30c3 100644
> --- a/kernel/rcu.h
> +++ b/kernel/rcu.h
> @@ -24,6 +24,7 @@
>  #define __LINUX_RCU_H
>  
>  #ifdef CONFIG_RCU_TRACE
> +#include <linux/trace_clock.h>
>  #define RCU_TRACE(stmt) stmt
>  #else /* #ifdef CONFIG_RCU_TRACE */
>  #define RCU_TRACE(stmt)
> @@ -118,4 +119,13 @@ int rcu_jiffies_till_stall_check(void);
>  
>  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
>  
> +static inline u64 notrace rcu_trace_clock_local(void)

"inline" now implies notrace. That is, we define inline to include
notrace in the headers. The 'notrace' now is redundant.

-- Steve

> +{
> +#ifdef CONFIG_RCU_TRACE
> +	return trace_clock_local();
> +#else /* #ifdef CONFIG_RCU_TRACE */
> +	return 0;
> +#endif /* #else #ifdef CONFIG_RCU_TRACE */
> +}
> +
>  #endif /* __LINUX_RCU_H */


