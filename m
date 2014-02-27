Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaB0TYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:24:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60915 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaB0TYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:24:41 -0500
Date: Thu, 27 Feb 2014 20:24:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 18/46] kernel: Mark functions as static in sched/fair.c
Message-ID: <20140227192435.GA27965@twins.programming.kicks-ass.net>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
 <20140227115805.GE9987@twins.programming.kicks-ass.net>
 <20140227160322.GC26756@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227160322.GC26756@thin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:03:22AM -0800, Josh Triplett wrote:
> On Thu, Feb 27, 2014 at 12:58:05PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 27, 2014 at 05:20:19PM +0530, Rashika Kheria wrote:
> > > @@ -5266,7 +5266,7 @@ static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
> > >  	return smt_gain;
> > >  }
> > >  
> > > -unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
> > > +static unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> > >  {
> > >  	return default_scale_smt_power(sd, cpu);
> > >  }
> > 
> > Fuck no; please think before sending.
> > 
> > I'm going to ignore all patches from you henceforth.
> 
> Did you perhaps check, and notice that there are *zero* uses of this
> function in the kernel?  Nothing overrides this weak symbol; it is no
> longer needed.  You removed the one and only user in your commit:

I know that; but you don't get to remove interfaces under the guise of a
static checker and without mention of such in the changelog.

You should bloody well know better.
