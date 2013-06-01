Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3FAQQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 12:16:09 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64569 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3FAQQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:16:02 -0400
Date: Sat, 1 Jun 2013 18:15:55 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130601161555.GE2132@rric.localhost>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <20130531091540.GH14076@nazgul.tnic>
 <20130531093210.GC2132@rric.localhost>
 <20130531122136.GA17843@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531122136.GA17843@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.05.13 14:21:36, Borislav Petkov wrote:
> On Fri, May 31, 2013 at 11:32:10AM +0200, Robert Richter wrote:
> > Hmm, since the changes in the onliner patches are either hard effort
> > to find in reviewing/testing or more or less related to the new
> > implementation, I better prefer to keep authorship as well to document
> > the code development (don't blame me about patch count ;)). We better
> > should add a branch (preferable at topic branch in tip?) as soon as
> > possible for this.
> 
> Yes, you should definitely keep authorship - simply state this in the
> commit message, add your SOB, etc. However, I don't want to have messy
> history for patches which haven't been reviewed yet. This complicates
> review needlessly and makes absolutely no sense for later when you stare
> at the history.

No, it's not about authorship in the sense of copyright, it's just
about keeping track of changes. My changes weren't related to a patch
review. In that case it would be totally fine to instantly merge the
changes.

Instead I reviewed the code while developing it with certain goals in
mind. Most changes I found necessary while building and running a
modified version during development. That never could be found in a
patch review. These changes are what we actually want to see in git
history.

And your argument that changes should be merged to reduce review
effort would actually mean to drop all the code you introduce which is
later removed in my patches (see below for the diff stats).

I also don't think we need to re-review your patches. Most of it has
been reviewed and should also not change much to avoid rebase
conflicts. In my point of view they are fine to be applied to a perf
topic branch. Ingo, would this be ok? There is no messy history if we
later just apply my patches on top. So no, I don't agree with you here
to merge some of my patches.

-Robert


 $ git diff tip/master...ras --stat kernel/
 kernel/events/Makefile      |   2 +-
 kernel/events/core.c        |  56 +++++++++++++++++++----------------
 kernel/events/internal.h    |   4 +++
 kernel/events/persistent.c  | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/events/ring_buffer.c |   7 ++---
 5 files changed, 214 insertions(+), 30 deletions(-)

 $ git diff ras...persistent --stat kernel/
 kernel/events/core.c       |   6 ++-
 kernel/events/internal.h   |   1 -
 kernel/events/persistent.c | 292 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------
 3 files changed, 221 insertions(+), 78 deletions(-)
