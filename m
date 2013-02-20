Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab3BTPWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:22:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33730 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852Ab3BTPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:22:38 -0500
Date: Wed, 20 Feb 2013 16:22:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
Message-ID: <20130220152234.GE16775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
	namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
	gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
	viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
	morten.rasmussen@arm.com
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-12-git-send-email-alex.shi@intel.com>
 <20130220121256.GD16775@pd.tnic>
 <5124DBA3.20605@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5124DBA3.20605@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:20:19PM +0800, Alex Shi wrote:
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index 2e8131d..0047856 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -4053,6 +4053,8 @@ struct lb_env {
> >>  	unsigned int		loop;
> >>  	unsigned int		loop_break;
> >>  	unsigned int		loop_max;
> >> +	int			power_lb;  /* if power balance needed */
> >> +	int			perf_lb;   /* if performance balance needed */
> > 
> > Those look like they're used like simple boolean flags. Why not make
> > them such, i.e. bitfields? See struct perf_event_attr for an example.
> 
> there are 11 long words in struct lb_env now. use boolean or bitfields
> can't save much space.

Now now maybe.

Btw, there's a ->flags variable there which simply cries to get another
LBF_* flag or two. This way you don't add any new members at all and
don't enlarge the struct.

> and not use conveniently.

Make yourself accessor functions or whatever.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
