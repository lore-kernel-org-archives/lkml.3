Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3IBSP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 14:15:26 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55709 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3IBSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:15:25 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 11:15:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] Making changes to the Coding Style
Message-ID: <20130902181510.GA29787@leaf>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378138205.1953.66.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 15:31 +0100, David Howells wrote:
> I have some questions about the process of changing the coding style:
>
>  (1) Should there be a procedure for changing the kernel coding style so that
>      people don't find out from checkpatch that what was fine yesterday now
>      gets you moaned at?

Yes; at a minimum, changes to checkpatch should have accompanying
changes to Documentation/CodingStyle adding new requirements.  I'll send
a patch momentarily adding a comment to that effect.

I would suggest that the maintainers of checkpatch should NAK any
patches adding new style rules without accompanying changes to
Documentation/CodingStyle documenting those rules.

>  (2) Where should changes be announced so that enough people see it that there
>      can be discussion?  I suggest that this not be LKML due to the amount of
>      noise.  Perhaps a kernel-announce list?

I don't think it makes sense to create subset lists for areas that
specific, and a general "interesting patches" list seems far too
subjective to not get drowned in random CCs from people who don't want
their patches lost in LKML noise.  I also suspect most of the
subscriptions to such a list would come from people interested in
bikeshedding, which seems counterproductive.  (Not suggesting that
changes shouldn't get wider review; they absolutely should.  But a
dedicated list for style changes seems likely to produce particularly
poor results.)

I suspect that a "file subscription" mechanism would prove more
effective.  Currently, people actually *responsible* for an area of the
kernel can put relevant patterns in MAINTAINERS to help ensure that they
see relevant patches.  patchwork.kernel.org already sees all kernel
patches sent to LKML and many other lists; I wonder how much work it
would take to enhance patchwork.kernel.org to let users add file
patterns for which they'd like any matching patch mails bounced to them
as though they were CCed?

In the meantime, you might consider subscribing to LKML and writing some
mail filters for subjects you care about.  I know several people who
systematically read subsets of LKML based on keyword filters.  For
instance, mails to LKML containing "rcu" tend to reach Paul McKenney,
CCed or not.

>  (3) Who maintains the coding style?  Who arbitrates since coding style is
>      very much subjective?

This is exactly the kind of area for which it helps to have a project
with a single top-level maintainer rather than a committee. :)

Anyone else "maintaining" CodingStyle could collect, group,
sanity-check, and forward patches, but I don't see how anyone could
sensibly claim to maintain it in the sense of making ACK/NAK judgement
calls.

>  (5) To what extent should local conditions be allowed to prevail?  For
>      example, in CodingStyle, there are different commenting rules for net/
>      and drivers/net/.  There are also unwritten variations in how various
>      bits of the tree are styled.

As little as possible; the point of CodingStyle is to avoid local style
rules.  The local style in net/ and drivers/net/ is already a wart;
let's avoid introducing more, and for any that already exist let's
consider carefully whether to document the unwritten variations or treat
them as bugs to fix.  Most of the time the latter seems like the right
answer.

>  (6) If the coding style does get changed, should existing lines within the
>      kernel then be retroactively changed?

Depends on the new style rule, how much benefit it provides, and how
much noise the change produces.  Ideally yes, but massive
checkpatch-based patches don't tend to go over well outside of staging.

In the case of extern, that seems like more of a "don't add any new
instances" rule than a "systematically purge existing instances" rule; I
don't see much benefit to removing existing instances, except as an
incidental part of making other changes in the same area.

checkpatch used to print the following warning about this when using
--file mode, but that got reverted in a later version; perhaps it should
return?

WARNING: Using --file mode. Please do not send patches to linux-kernel
that change whole existing files if you did not significantly change most
of the file for other reasons anyways or just wrote the file newly
from scratch. Pure code style patches have a significant cost in a
quickly changing code base like Linux because they cause rejects
with other changes.

- Josh Triplett
