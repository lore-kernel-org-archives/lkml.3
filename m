Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3GOVw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:52:58 -0400
Received: from 1wt.eu ([62.212.114.60]:34680 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab3GOVw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:52:57 -0400
Date: Mon, 15 Jul 2013 23:52:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable kernel, let's dump the cc: stable tag
Message-ID: <20130715215246.GB12242@1wt.eu>
References: <1373916476.2748.69.camel@dabdike> <1373917517.17876.193.camel@gandalf.local.home> <20130715195505.GE10157@1wt.eu> <1373921779.17876.200.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373921779.17876.200.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:56:19PM -0400, Steven Rostedt wrote:
> I'm temporarily maintaining a 3.6 stable release (can't wait till I
> don't have to do that anymore). And I cheat. I use the trees that Greg
> uses, and I still spend days getting it ready.

I've been doing the same for a long time (still doing it for 2.6.32).
I couldn't do it without Greg's selection of patches and help, quite
frankly. I still don't know how he manages to support that many trees
in parallel with that regular frequency. Maybe he's more resistant to
effort than us.

> I think the current method does not scale. It's only been doing so well
> only because Greg has been putting a lot of time and effort into it. But
> I still think the process is broken.

In my opinion, it's not broken, but it's fragile.

> Do I think this will add more work to the maintainer? Yes, definitely!
> But we have hundreds of maintainers, and only one Greg. Where do you
> think we should be adding the work too?

I agree on this point, except that maintainers exchange with Greg, and
more exchanges inevitably means more work for Greg.

> In another KS topic, we talked about backup maintainers. This could be
> the job of #2.

Backup is for an active-backup setup. You're suggesting an active-active
one, which can be quite different, even maybe in terms of funding.

> Yes, there's already a automatic response, but who really looks a those.

I think more than you imagine on average. And anyway, when some patches
break and require a fix that was known at the time of the review, we
should shout (sorry Sarah) on the authors for not mentionning it during
the review. A review is a responsible process. You're giving your consent
for some of your work being merged in kernels that will be deployed in
zillions of devices. It's not just a formality.

> I know I'm guilty of seeing that and saying to myself "oh good, Greg
> added that patch" and not actually review it. This process may force me
> to look at it better.

Then better save a mail exchange and start reviewing them with more
attention. Maybe Greg should let more time for reviews. For example I
have learned that old kernels are of less importance to maintainers
(which is expected) and if some want to perform a deep review, they
need some time to set up an environment (we all have dirty things in
our trees and don't want to checkout -f to an old code just for a
review, do we?). So I increased from 3 days to one week lately and
it increased the feedback. I don't know if current maintainers already
get bored by reviews, but I think this is the point which needs to be
reinforced if they do.

> It may not be efficient for maintainers, but as maintainers we should
> spend a bit more time on stable releases. If you do that up front before
> marking commits with the stable tag, then just setup a mail filter that
> simply forwards the email to the second address that Greg will take. If
> you abuse that, then Greg can get nasty with you ;-)

Then let's save one step and remind people that by putting a Cc: stable tag,
you agree to take care of reviewing what you have sent and to notify about
known missing fixes or any pending issues which require the patch to be
postponed.

That's probably where the Cc:stable unveils some laziness we discussed
about with Greg. It's too easy to add "Cc:stable" and consider that it's
someone else's job as of now to backport and check.

If you're not willing to review fixes sent by you, please do not Cc
stable in your patches, that's really better for the process. (I'm not
saying that to you specifically, but as a rule to put in the doc).

Best regards,
Willy

