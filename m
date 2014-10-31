Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaJaQ54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:57:56 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59176 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaJaQ5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:57:53 -0400
Date: Fri, 31 Oct 2014 12:57:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141031165749.GB18792@htj.dyndns.org>
References: <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <CAAAKZwvJOKsrj_yczDGaNLaNYo+_=HzsTLwDdcaTJqO2VMy8uA@mail.gmail.com>
 <20141030171247.GC378@htj.dyndns.org>
 <CAAAKZwsGs4e1T8Xb=kEGY3O=ZJS4DgOe7Oi5UPUXz5cwiRcH9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwsGs4e1T8Xb=kEGY3O=ZJS4DgOe7Oi5UPUXz5cwiRcH9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tim.

On Thu, Oct 30, 2014 at 03:35:44PM -0700, Tim Hockin wrote:
> I think the conversation is well enough understood by the people for
> whom this bit of snark was intended that reading my mind was not that

I really don't think it is.  cgroups in general isn't that well
understood and while some may be familiar with what they've been
working on, most aren't too well acquainted what changes are made and
why.  I surely am responsible for not being better at communicating
but it took me quite a while and I'm still in the process of
crystalizing those myself.

> hard.  That said, it was overly snark-tastic, and sent in haste.

The problem with this type of snarky one liner is that it undermines
the fundamentals of techunical discussions on the mailing list.  It
requires too much effort on the other party for speculation and if the
other party doesn't repond, the snark comment succeeds at establishing
the vague negativity that it carried.  If you have a technical
opinion, form and communicate it properly so that it can be analyzed
and discussed properly.  I think my wording in my previous messages
was too strong and apologize for that but please don't do this.

> My point, of course, was that here is an example of something which
> maps very well to the idea of cgroups (a set of processes that share
> some controller) but DOES NOT map well to the unified hierarchy model.

I'm pretty sure that conclusion is premature.  As I wrote in my reply
to Peter, I strongly believe that a set of reasonable constraints and
conventions lead to a much better and more functional design,
interface and implementation.  It sure can feel like an annoyance if
one used to be accustomed to doing whatever and now has to follow
these new constraints but we were paying heavily elsewhere for the
lack of consistency and, in general, sense.

I could have communicated it clearer but the fundamental issue that I
see with the original proposal is that it conflates task organization
and controller configuration.  They belong to different planes of
control and should be orthogonal as much as possible.  This shows up
evidently, for example, in how errors are reported.  A write to a knob
of the involved controller failing with the proper error code is a far
superior way compared to failing mkdir or task migration.  The only
reason we even think that doing anything else is fine is because we've
never thought about what's the right thing to do all along and just
did whatever is convenient in terms of immediate implementation for
each individual case.

> It must be managed more carefully than arbitrary hierarchy can
> enforce.  The result is the mish-mash of workarounds proposed in this
> thread to force it into arbitrary hierarchy mode, including this
> no-win situation of running out of hardware resources - it is going to
> fail.  Will it fail at cgroup creation time (doesn't scale to
> arbitrary hierarchy) or will it fail when you add processes to it
> (awkward at best) or will it fail when you flip some control file to
> enable the feature?

Please see above.  It's more of the process of finding the *right*
place to put operations and their failures.  Task migration sure can
fail due to memory pressure or basic cgroup organizational contraints;
however, it's outright wrong to fail it because a given controller can
support only limited number of configurations.  Again, being able to
do whatever one wanna do often doesn't lead to a good design.

> I know the unified hierarchy ship has sailed, so there's not
> non-snarky way to argue the point any further, but this is such an
> obvious case, to me, that I had to say something.

If you properly compose your ideas and concerns, I can think about and
discuss them and make adjustments where appropriate and it seems to me
that your impression at least in this instance isn't very well
warranted.  The snark comment can achieve none of the productive
things which can come from proper discussions.  All it can do is
aggravating the tone of the discussion, so, again, please refrain from
it in the future.

Thanks.

-- 
tejun
