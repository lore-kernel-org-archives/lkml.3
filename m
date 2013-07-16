Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3GPHno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:43:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40571 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab3GPHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:43:42 -0400
Message-ID: <1373960616.2148.34.camel@dabdike>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 11:43:36 +0400
In-Reply-To: <20130716062058.GB19052@kroah.com>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com> <1373951852.2148.9.camel@dabdike>
	 <20130716062058.GB19052@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 23:20 -0700, Greg KH wrote:
> On Tue, Jul 16, 2013 at 09:17:32AM +0400, James Bottomley wrote:
> > On Mon, 2013-07-15 at 14:44 -0700, Greg KH wrote:
> > > On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
> > > > Before the "3.10.1-stable review" thread degenerated into a disagreement
> > > > about habits of politeness, there were some solid points being made
> > > > which, I think, bear consideration and which may now be lost.
> > > > 
> > > > The problem, as Ji???? Kosina put is succinctly is that the distributions
> > > > are finding stable less useful because it contains to much stuff they'd
> > > > classify as not stable material.
> 
> And I'm going to be working on that.

OK, I accept that.

> But I need, from the distros, specific examples of what they object to.
> So far all I've gotten is one security patch (that was needed), and one
> patch for sysfs that I backported too far in the version numbers (my
> fault.)
> 
> Given the huge number of stable patches over the past few years, only
> having 2 patches be an issue sounds like things are working well for
> people here.
> 
> If I don't get pushback, with specifics, from the distros, I will not
> know what to change, so if people can provide me that, it will help out
> a lot.

I agree ... I think Jiří and his Red Hat equivalent need to pipe up and
give us more examples of the problems they've been having.

> > > I don't like this at all, just for the simple reason that it will push
> > > the majority of the work of stable kernel development on to the
> > > subsystem maintainers, who have enough work to do as it is.
> > 
> > Well, I think of this as a feature not a bug because it enables scaling,
> > but we can certainly debate the topic; it's probably one of the more
> > important things that should be discussed.
> 
> How does this scale?  It makes the maintainers do more work, which does
> not scale at all.

We obviously have different ideas of what "scaling" means.  Being a
mathematician I think of a process were you review everything as o(1)
and where the maintainers review everything as o(n).  Since the number
of patches (np) tends to grow as the number of maintainers, np/o(n) is
an approximate constant meaning the amount of work per maintainer
scales.  np/o(1) grows.

> > > Stable tree stuff should cause almost _no_ extra burden on the kernel
> > > developers, because it is something that I, and a few other people, have
> > > agreed to do with our time.  It has taken me 8 _years_ to finally get
> > > maintainers to agree to mark stuff for the stable tree, and fine-tune a
> > > development process that makes it easy for us to do this backport work.
> > > 
> > > I _want_ the exact same commit that is in Linus's tree for the backport
> > > because if I have to rely on a maintainer to do the backport and resend
> > > it, I _know_ it will usually be a changed patch, and the git commit id
> > > will be lost.
> > 
> > This is fixable with process and tools, surely.
> 
> That's crazy,

Fixing a problem you just complained about with a suggestion involving
process and tools is crazy? I think I want some of what you're on.

>  and it implies that there is a problem today with the Cc:
> tag.
> 
> Is there?  What is the problem that you are seeing that you wish to help
> resolve?

To repeat: the problem, as I see it, is that the tag gets applied at the
leaves of the tree.  It can't be stripped in a normal git workflow, so
the process for adding it doesn't get enough review to ensure our stable
tree contains the correct patches.

> I don't think it's the same problem that I am seeing, as adding more
> tools and processes sure isn't going to fix that.
> 
> > > Have I missed anything else that the distros are objecting to?  The
> > > "smaller" distros (i.e. ones without lots of kernel developers) have
> > > been giving me nothing but _thanks_ and appreciation with the way that
> > > I've been sucking in all of the different fixes.  Do we want to mess
> > > with a process that is really working out well for them, and only causes
> > > annoyance at times by the larger ones?
> > 
> > I still think the scaling problem remains plus, if you push back more,
> > it's going to increase friction: you aren't necessarily in the best
> > position to know what should be a stable fix for a given subsystem, and
> > if you push back incorrectly it's going to annoy the maintainer.
> 
> Making a subsystem maintainer answer "why is this needed" is really
> going to annoy people?  Seriously?

Pushing back wrongly is, yes, it's just human nature.

>From a human nature perspective, the friction to inclusion rises
globally as the current kernel goes through the -rc cycle.  There's no
such natural cadence for stable.  It's the general level of friction
that needs to rise for stable and I'm not sure that individual pushback
does that. 

> Let's try it out, and see what happens.

Well, experiment is the best teacher, yes, let's see how it works out.

> I think the real stable issue that _everyone_ keeps ignoring, is my
> original complaint, in that people are using the -rc1 merge window to
> get fixes in they should have sent to Linus for .0.

You mean we delay fixes to the merge window (tagged for stable) because
we can't get them into Linus' tree at -rc5 on?  Guilty ... that's
because the friction for getting stuff in rises.  It's a big fight to
get something marginal in after -rc5 ... it's easy to silently tag it
for stable (did I mention that I think the tag part enables this
behaviour?).

> I don't see anything you have written so far that will help resolve that
> issue, which is not good, as that needs to be taken care of.

Removing the tag removes the behaviour ... it looks like a fairly simple
(albeit naïve) solution to me.

James


