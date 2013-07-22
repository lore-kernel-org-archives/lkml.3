Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3GVBZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:25:23 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:60149 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab3GVBZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:25:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYNAJGJ7FF5LPxH/2dsb2JhbABagwa8BIUsBAGBDhd0giQBAQU6HBYKAxAIAxgJJQ8FJQMhE4gPtlEWjkgbgR0HgxBuA5dckU6DJCqBLCQ
Date: Mon, 22 Jul 2013 11:25:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Message-ID: <20130722012517.GD11674@dastard>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 12:53:10PM -0700, Linus Torvalds wrote:
> So it's been another week, and -rc2 is out there.
> 
> The patch looks a bit odd, because by bulk 95% of the patch is just
> the removal of the CSR staging driver that wasn't getting any
> traction, so the diffstat (and the dirstat in particular) is not very
> interesting or readable, since that driver removal basically
> overshadows everything else. But I do admit to love seeing code
> removal patches.
> 
> And of the rest of the patch, a noticeable part is all those
> one-liners all over that just remove the __cpuinit markers that people
> agreed were just more pain than gain to maintain. We had already made
> the markers be no-ops earlier, so they didn't matter for code
> generation, and here in rc2 they get actually removed.
> 
> End result: we have two separate events that generate a lot of noise
> in the patch, but aren't really interesting per se. They do make the
> patch harder to read, though.
> 
> Ignoring those noisy parts of the patch, there's a couple of things
> worth noting about rc2. I think most of the patches here are nice
> fixes, but I wanted to give two heads-ups:
> 
>  (a) the O_TMPFILE flag that is new to 3.11 has been going through a
> few ABI/API cleanups (and a few fixes to the implementation too), but
> I think we're done now. So if you're interested in the concept of
> unnamed temporary files, go ahead and test it out. The lack of name
> not only gets rid of races/complications with filename generation, it
> can make the whole thing more efficient since you don't have the
> directory operations that can cause serializing IO etc.

I'll just point out that it can make the whole thing worse, too.
For example, for ext3/4, the tmpfile being created has to be added
to the orphan inode list which is protected by a filesystem global
mutex. Hence scalability of O_TMPFILE is massively limited on
ext3/ext4 due to architectural issues within ext3/4. Other
filesystems will be more efficient, but because they have more
scalable/complex orphan inode handling it's going to take longer to
implement O_TMPFILE support for them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
