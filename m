Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaGKPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:12:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49799 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaGKPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:12:44 -0400
Date: Fri, 11 Jul 2014 08:12:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, dipankar@in.ibm.com
Subject: Re: [PATCH] rcu: define tracepoint strings only if CONFIG_TRACING is
 set
Message-ID: <20140711151239.GJ16041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405078692-29957-1-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405078692-29957-1-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071115-7164-0000-0000-000003106BB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:38:12PM +0200, Ard Biesheuvel wrote:
> Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
> infrastructure") unconditionally populates the __tracepoint_str input section,
> but this section is not assigned an output section if CONFIG_TRACING is not set.
> This results in the __tracepoint_str turning up in unexpected places, i.e.,
> after _edata.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: rostedt@goodmis.org
> Cc: dipankar@in.ibm.com
> Cc: paulmck@linux.vnet.ibm.com

If you get a Reviewed-by from Steven Rostedt, I will be happy to queue
this one.

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index f1ba77363fbb..ac1984149eb5 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -79,9 +79,16 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
>   * the tracing userspace tools to be able to decipher the string
>   * address to the matching string.
>   */
> +#ifdef CONFIG_TRACING
> +#define DEFINE_TPS(sname) \
> +static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
> +#else
> +#define DEFINE_TPS(sname)
> +#endif
> +
>  #define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
>  static char sname##_varname[] = #sname; \
> -static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
> +DEFINE_TPS(sname) \
>  struct rcu_state sname##_state = { \
>  	.level = { &sname##_state.node[0] }, \
>  	.call = cr, \
> -- 
> 1.8.3.2
> 

