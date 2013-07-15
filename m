Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3GOT2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:28:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39254 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504Ab3GOT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:28:00 -0400
Message-ID: <1373916476.2748.69.camel@dabdike>
Subject: KS Topic request: Handling the Stable kernel, let's dump the cc:
 stable tag
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ksummit-2013-discuss@lists.linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 23:27:56 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the "3.10.1-stable review" thread degenerated into a disagreement
about habits of politeness, there were some solid points being made
which, I think, bear consideration and which may now be lost.

The problem, as Jiří Kosina put is succinctly is that the distributions
are finding stable less useful because it contains to much stuff they'd
classify as not stable material.

The question that arises from this is who is stable aiming at ...
because if it's the distributions (and that's what people seem to be
using it for) then we need to take this feedback seriously.

The next question is how should we, the maintainers, be policing commits
to stable.  As I think has been demonstrated in the discussion the
"stable rules" are more sort of guidelines (apologies for the pirates
reference).  In many ways, this is as it should be, because people
should have enough taste to know what constitutes a stable fix.  The
real root cause of the problem is that the cc: stable tag can't be
stripped once it's in the tree, so maintainers only get to police things
they put in the tree.  Stuff they pull from others is already tagged and
that tag can't be changed.  This effectively pushes the problem out to
the lowest (and possibly more inexperienced) leaves of the Maintainer
tree.  In theory we have a review stage for stable, but the review
patches don't automatically get routed to the right mailing list and the
first round usually comes out in the merge window when Maintainers'
attention is elsewhere.

The solution, to me, looks simple:  Let's co-opt a process we already
know how to do: mailing list review and tree handling.  So the proposal
is simple:

     1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
        reviewed patch to stable
     2. All patches to stable should follow current review rules: They
        should go to the mailing list the original patch was sent to
        once the original is upstream as a request for stable.
     3. Following debate on the list, the original maintainer would be
        responsible for collecting the patches (including the upstream
        commit) adjudicating on them and passing them on to stable after
        list review (either by git tree pull or email to stable@).

I contend this raises the bar for adding patches to stable much higher,
which seems to be needed, and adds a review stage which involves all the
original reviewers.

Oh, and did someone mention plum brandy ...?

James


