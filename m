Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3GOUUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:20:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64954 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3GOUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:20:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18JevfpuNO0GlpBtPHzDONJ88rDHMFzX+w=
Date: Mon, 15 Jul 2013 16:20:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the
 cc: stable tag
Message-ID: <20130715202037.GB12062@titan.lakedaemon.net>
References: <1373916476.2748.69.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373916476.2748.69.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:27:56PM +0400, James Bottomley wrote:
...
> The solution, to me, looks simple:  Let's co-opt a process we already
> know how to do: mailing list review and tree handling.  So the proposal
> is simple:
> 
>      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
>         reviewed patch to stable
>      2. All patches to stable should follow current review rules: They
>         should go to the mailing list the original patch was sent to
>         once the original is upstream as a request for stable.
>      3. Following debate on the list, the original maintainer would be
>         responsible for collecting the patches (including the upstream
>         commit) adjudicating on them and passing them on to stable after
>         list review (either by git tree pull or email to stable@).
> 
> I contend this raises the bar for adding patches to stable much higher,
> which seems to be needed, and adds a review stage which involves all the
> original reviewers.

If I may expand on the 'tree-handling' with an idea:

When I'm collecting up patches for mvebu, the first thing I do is
classify the patch as a fix for the current -rc cycle, or for next.  It
would be very easy to maintain a stable branch "ahead of" fixes.  More
accurately, one for each stable version.  eg:

stable-3.2
stable-3.4
stable-3.9
stable-3.10
fixes
cleanup (or next)
...

Each branch would need to be based on a commit in the mainline tree, eg
stable-3.2 would be based on v3.2, not v3.2.48.

Anything I suspect is stable material goes in the earliest relevant
stable branch, and I send an email series to the linux-stable list.
Discussion ensues, maybe I remove one or two patches from the stable
branch and only put them in fixes (so, for -rcX), and send the PR.  The
stable team can then merge the PR, once they see the commit in mainline.

The big advantage of this proposal is that the patch would have the same
commit id in both trees.  'git branch -a --contains <commit-ish>' would
work.

The main problem with this is that maintainers would need to do the
legwork themselves to figure out how far back a patch is relevant for.
Maybe this would be a feature? ;-)

Unfortunately, since most of the time there's just a single patch, I'm
not sure the cost of the merge commits is worth the benefit of having
the same commit id in stable and mainline.

thx,

Jason.
