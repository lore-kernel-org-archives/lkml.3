Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3GOTzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:55:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34674 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab3GOTzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:55:15 -0400
Date: Mon, 15 Jul 2013 21:55:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable kernel, let's dump the cc: stable tag
Message-ID: <20130715195505.GE10157@1wt.eu>
References: <1373916476.2748.69.camel@dabdike> <1373917517.17876.193.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373917517.17876.193.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Mon, Jul 15, 2013 at 03:45:17PM -0400, Steven Rostedt wrote:
> How about this as a proposal.
> 
> Keep the Cc: stable@ tag as it is today.
> 
> Have Greg, or whoever, change his script to not take commits marked for
> stable, but instead, forward the commit to the maintainer. Or as it
> already does today, to everyone on the Cc, and -by: tags. Change the
> script from being "stable review" to say "Look to see what you want, and
> resend what is needed for stable".
> 
> Then the maintainer needs to look at all the patches that were marked
> for stable, and resend them to Greg saying which ones should go into
> stable.
> 
> This has a few advantages.
> 
> 1) lets anyone still mark their patch as a stable fix, even if at the
> end isn't.
> 
> 2) Some commits can be marked for stable, for those that want to read
> git logs, but not send to stable (the Fixes: tag as described in another
> thread).
> 
> 2) Makes the stable decision go where it belongs. To the maintainer of
> that system. It lets the maintainer think twice about what goes to
> stable or not.
> 
> 3) gives a little more time if needed, to let stable commits stir in
> mainline. If its a security fix, the maintainer should be on the ball to
> get in to stable, and not just let Greg worry about it.
> 
> 4) Probably the most important. It should unload most of the work off of
> Greg, and push it more on the maintainers. Greg would just need to make
> sure the patch goes to the right person (probably not an issue, as it is
> most likely on the Signed off by line). Then the maintainers could
> review the commits that should go to stable, and if needed, not send
> them. They could also send commits that were not marked for stable, as
> long as they are already in mainline.
> 
> Also, we could mandate that the maintainers do the backports too.

I disagree with your proposal. All these points are already covered by
the stable review and the early notification that the greg-bot does when
the patch is included in the queue. If submitters/maintainers do not read
these e-mails sent to them about changes going to happen in the subsystems
they're responsible for, having them resend the patches will only punish
the honnest ones. The other ones will simply reply without doing anything
else. In the end, we get more work to get fixes merged so less efficiency.

I tend to think the merge should be slightly less automatic or at least
add some delay (post release for late submissions), but what I'm worried
about is that adding exceptions to the workflow will mean more work for
Greg, so we should be careful about this, as we have a single one and we
don't want to burn him out.

Regards,
Willy

