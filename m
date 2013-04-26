Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab3DZGcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 02:32:22 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33286 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3DZGcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 02:32:21 -0400
Date: Fri, 26 Apr 2013 08:32:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print out additional debugging advice when we hit lockdep BUGs
Message-ID: <20130426063217.GE25912@gmail.com>
References: <20130423163403.GA12839@redhat.com>
 <20130424064813.GB27551@gmail.com>
 <20130425174002.GA26769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425174002.GA26769@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Wed, Apr 24, 2013 at 08:48:13AM +0200, Ingo Molnar wrote:
> 
>  > These patterns repeated in 4 places really call for a common helper 
>  > defined as print_lockdep_off(fmt...) or so?
>  > 
>  > (Can be a followup patch if that's easier for you.)
> 
> Given there was only one case which was really different, I opted not to 
> bother with varargs, and just pass the one string that changes and add 
> an extra printk for that special case (MAX_LOCK_DEPTH)
> 
> -- 
> 
> Consolidate the lockdep "too low" messages into one function.
> Also add some missing printk levels.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e4c001f..be52e6d 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -380,6 +380,13 @@ static int verbose(struct lock_class *class)
>  unsigned long nr_stack_trace_entries;
>  static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
>  
> +static void print_lockdep_off(const char *which)
> +{
> +	printk(KERN_DEBUG "BUG: %s too low!\n", which);
> +	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
> +	printk(KERN_DEBUG "Attach output of /proc/lock_stat to bug report\n");
> +}
> +

Yeah, that looks perfectly fine - thanks!

( I tweaked it a tiny bit to pass in a generic bug-string instead of 
  assuming that the warning is necessarily about some 'too low' value. 
  This makes actual usage sites of print_lockdep_off() easier to read and 
  closer to existing WARN() patterns. )

Thanks,

	Ingo
