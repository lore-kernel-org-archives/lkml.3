Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3KDMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:19:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48348 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3KDMTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:19:35 -0500
Date: Mon, 4 Nov 2013 13:19:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Maxim Patlasov <mpatlasov@parallels.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131104121933.GA24407@amd.pavel.ucw.cz>
References: <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
 <20131029205756.GH9568@quack.suse.cz>
 <CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
 <20131029221324.GC12814@quack.suse.cz>
 <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
 <20131101172222.GA19478@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101172222.GA19478@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, but then the temp-file is long-lived enough that it *will* hit
> > the disk anyway. So it's only the "create temporary file and pretty
> > much immediately delete it" case that changes behavior (ie compiler
> > assembly files etc).
> > 
> > If the temp-file is for something like burning an ISO image, the
> > burning part is slow enough that the temp-file will hit the disk
> > regardless of when we start writing it.
> 
> The temp-file IO avoidance is an optimization not a guarantee. If a
> user want to avoid IO seriously, he will probably use tmpfs and
> disable swap.

No, sorry, they can't. Assuming ISO image fits in tmpfs would be
cruel.

> So if we have to do some trade-offs in the optimization, I agree that
> we should optimize more towards the "large copies to USB stick" use case.
> 
> The alternative solution, per-bdi dirty thresholds, could eliminate
> the need to do such trade-offs. So it's worth looking at the two
> solutions side by side.

Yes, please.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
