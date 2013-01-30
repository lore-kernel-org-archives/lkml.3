Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3A3Mv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:51:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42840 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3A3Mvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:51:52 -0500
Date: Wed, 30 Jan 2013 13:51:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: paul.szabo@sydney.edu.au, 695182@bugs.debian.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
Message-ID: <20130130125151.GB19069@amd.pavel.ucw.cz>
References: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au>
 <50F4A92F.2070204@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F4A92F.2070204@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I understand that more RAM leaves less lowmem. What is unacceptable is
> > that PAE crashes or freezes with OOM: it should gracefully handle the
> > issue. Noting that (for a machine with 4GB or under) PAE fails where the
> > HIGHMEM4G kernel succeeds and survives.
> 
> You have found a delta, but you're not really making apples-to-apples
> comparisons.  The page tables (a huge consumer of lowmem in your bug
> reports) have much more overhead on a PAE kernel.  A process with a
> single page faulted in with PAE will take at least 4 pagetable pages
> (it's 7 in practice for me with sleeps).  It's 2 pages minimum (and in
> practice with sleeps) on HIGHMEM4G.
> 
> There's probably a bug here.  But, it's incredibly unlikely to be seen
> in practice on anything resembling a modern system.  The 'sleep' issue
> is easily worked around by upgrading to a 64-bit kernel, or using

Are you saying that HIGHMEM configuration with 4GB ram is not expected
to work?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
