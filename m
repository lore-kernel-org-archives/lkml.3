Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaB0QDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:03:34 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42990 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaB0QDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:03:33 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 27 Feb 2014 08:03:22 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 18/46] kernel: Mark functions as static in sched/fair.c
Message-ID: <20140227160322.GC26756@thin>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
 <20140227115805.GE9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227115805.GE9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:58:05PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 27, 2014 at 05:20:19PM +0530, Rashika Kheria wrote:
> > @@ -5266,7 +5266,7 @@ static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
> >  	return smt_gain;
> >  }
> >  
> > -unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
> > +static unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> >  {
> >  	return default_scale_smt_power(sd, cpu);
> >  }
> 
> Fuck no; please think before sending.
> 
> I'm going to ignore all patches from you henceforth.

Did you perhaps check, and notice that there are *zero* uses of this
function in the kernel?  Nothing overrides this weak symbol; it is no
longer needed.  You removed the one and only user in your commit:

commit ee08d1284ea9235b29bd2d9b7493b4b4cf3da09c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Jun 13 15:24:45 2012 +0200

    sched/x86: Remove broken power estimation

    The x86 sched power implementation has been broken forever and gets in
    the way of other stuff, remove it.

When I reviewed Rashika's patch and provided a Reviewed-by, I provided
the following feedback:

Josh Triplett wrote:
> I'd suggest waiting to see how the scheduler folks respond to this patch
> series, and then if they accept the changes marking unused __weak
> functions as static, you could follow up with a patch that folds them
> into their callers and gets rid of them entirely.

(That feedback was based on the assumption that the simplest possible
mark-it-static patch would be a good starting point.)

Now, given all of the above, perhaps you could provide some useful
feedback on what you find so objectionable about this patch?

- Josh Triplett
