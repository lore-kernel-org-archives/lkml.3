Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbaELU4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:56:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50330 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbaELU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:56:16 -0400
Date: Mon, 12 May 2014 22:56:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug: Slow down hotplug operations
Message-ID: <20140512205614.GA12044@amd.pavel.ucw.cz>
References: <1399492661-891-1-git-send-email-bp@alien8.de>
 <20140507130655.9f7c46de8cb39726079458fb@linux-foundation.org>
 <alpine.DEB.2.02.1405072214420.6261@ionos.tec.linutronix.de>
 <20140507202655.GI16722@pd.tnic>
 <20140511170234.GA2681@xo-6d-61-c0.localdomain>
 <alpine.DEB.2.02.1405112026580.6261@ionos.tec.linutronix.de>
 <20140511184808.GC15527@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511184808.GC15527@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-05-11 20:48:08, Borislav Petkov wrote:
> On Sun, May 11, 2014 at 08:29:30PM +0200, Thomas Gleixner wrote:
> > On Sun, 11 May 2014, Pavel Machek wrote:
> > > Well. If you add the delay, you'll mask real problems and cause regressions when
> > > the delay is removed -- because fix-hotplug will probably take time to get right.
> > > 
> > > Bad idea, AFAICT.
> > 
> > Agreed, but Boris is right, that the current duct tape hackery needs
> > to stop. And the delay was the desperate attempt to wake up people to
> > focus on replacing the current mess instead of making it more
> > entangled.
> 
> I think Pavel is missing the point: the delay will be removed with the
> rewrite of cpu hotplug, after it actually works reliably. Then we won't
> need delay anyway.

Well.. and if you don't get it right at the first try, you'll get
regression and bisect pointing at delay removal. Also... with delay in
place, you won't notice if it gets less reliable.

printk() or comment should deter people from filling bug reports....

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
