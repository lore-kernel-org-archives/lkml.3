Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaLPUgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:36:12 -0500
Received: from imap.thunk.org ([74.207.234.97]:59511 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaLPUgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:36:10 -0500
Date: Tue, 16 Dec 2014 15:35:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de, bp@alien8.de,
        gnomes@lxorguk.ukuu.org.uk, computersforpeace@gmail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] Stop maintainer abuse
Message-ID: <20141216203546.GU17575@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jonathan Corbet <corbet@lwn.net>,
	Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
	bp@alien8.de, gnomes@lxorguk.ukuu.org.uk,
	computersforpeace@gmail.com, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <20141216130939.166c4369@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141216130939.166c4369@lwn.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:09:39PM -0500, Jonathan Corbet wrote:
> 
> In general, I worry about trying to codify things too much just because
> different maintainers have different expectations.  As Linus noted, some
> maintainers have their work done by the time the merge window starts and
> can take patches just fine — until something catches fire, at least.

Yeah, I think it's going to be really different pretty much all
maintainers.

Speaking for myself, that's what patchwork is for.  There are plenty
of other times besides merge window when I'm going to be super busy
--- say, because I'm travelling to a conference or for business
reasons.  And those times are far more likely to be hard on me as a
maintainer compared to the merge window.  So everyone's mileage going
to vary widely.

And having a strict schedule like this:

+  kernel.org "mainline:"  |  Patch may appear
+  field when posted       |  in released kernel
+  ------------------------+--------------------------------
+  3.18-rc[1-4]            |  3.19
+  3.18-rc[5-9]            |  3.20
+  3.18                    |  Merge window open - don't post
+  3.19-rc[1-4]            |  3.20
+  3.19-rc[5-9]            |  3.21
+  3.19                    |  Merge window open - don't post
+
+Bug fixes can typically be accepted at any time.

Seems like it's very, VERY bad ju-ju.  I'll take some feature patches
as late as -rc6, if they are simple and I'm confident that regression
testing will catch any problems (because for file systems, very often
xfstests is far more likely to find problems than soak time in
linux-next).

On the flip side, a feature patch, submitted between -rc2 and -rc3,
might not make it because we want more people to look at it, better
benchmarks, etc., etc.  Even a bug fix submitted at that point might
not make it, especially if the bug is extremely rare (and we may have
lived with it for years or decades), and the change is especially
risky/hairy.

So having a schedule like this is very likely going to set all sorts
of false expectations, and may end up causing just as many problems as
it purports to solve.

I wonder if this sort of thing is better placed in various unofficial
documentations which help new users acculturate.  For example, see
some of the slides in the last half of Sarah Sharp's presentation
here:

https://plus.google.com/+SarahSharp/posts/4GSqqGpg8cg

That has the advantage of significantly reducing the risk that things
that originally started out as preferences by a few maintainers
getting turned into bureaucratic rules.

					- Ted
