Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaCVRtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:49:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:49:07 -0400
Date: Sat, 22 Mar 2014 10:55:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tytso@mit.edu
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140322105524.7baec73a.akpm@linux-foundation.org>
In-Reply-To: <20140322173207.GC23583@thunk.org>
References: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
	<20140321130055.c0ea32946f3543cd7f6bedd6@linux-foundation.org>
	<20140322170322.GA23583@thunk.org>
	<20140322101512.eaeb542b.akpm@linux-foundation.org>
	<20140322172606.GB23583@thunk.org>
	<20140322173207.GC23583@thunk.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014 13:32:07 -0400 tytso@mit.edu wrote:

> On Sat, Mar 22, 2014 at 01:26:06PM -0400, tytso@MIT.EDU wrote:
> > > Well.  Converting an existing retry-for-ever caller to GFP_NOFAIL is
> > > good.  Adding new retry-for-ever code is not good.
> 
> Oh, and BTW --- now that checkpatch.pl now flags an warning whenever
> GFP_NOFAIL is used

I don't know what the basis for this NOFAIL-is-going-away theory could
have been.  What's the point in taking a centrally implemented piece of
logic and splattering its implementation out to tens of different
callsites?

Obviously I was asleep when I merged that checkpatch change.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/checkpatch.pl: __GFP_NOFAIL isn't going away

Revert 7e4915e78992eb ("checkpatch: add warning of future __GFP_NOFAIL use").

There are no plans to remove __GFP_NOFAIL.

__GFP_NOFAIL exists to

a) centralise the retry-allocation-for-ever operation into the core
   allocator, which is the appropriate implementation site and

b) permit us to identify code sites which aren't handling memory
   exhaustion appropriately.

Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ------
 1 file changed, 6 deletions(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-__gfp_nofail-isnt-going-away scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-__gfp_nofail-isnt-going-away
+++ a/scripts/checkpatch.pl
@@ -4240,12 +4240,6 @@ sub process {
 			     "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
 		}
 
-# check for GFP_NOWAIT use
-		if ($line =~ /\b__GFP_NOFAIL\b/) {
-			WARN("__GFP_NOFAIL",
-			     "Use of __GFP_NOFAIL is deprecated, no new users should be added\n" . $herecurr);
-		}
-
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
 			if (WARN("ONE_SEMICOLON",
_

