Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaFNUcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:32:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaFNUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:32:48 -0400
Date: Sat, 14 Jun 2014 22:32:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: Mike Galbraith <mgalbraith@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Slow down stupid pounders
Message-ID: <20140614203220.GB3853@xo-6d-61-c0.localdomain>
References: <20140506102924.GA25013@pd.tnic>
 <1399388899.5192.273.camel@marge.simpson.net>
 <20140506161004.GC25013@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506161004.GC25013@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-05-06 18:10:04, Borislav Petkov wrote:
> On Tue, May 06, 2014 at 05:08:19PM +0200, Mike Galbraith wrote:
> > Rather than ratelimit the interface perhaps send a ratelimited note
> > telling the user straight up that he's begging for trouble. We can
> > ignore it when regression testing, and point it out to Joe Pounder
> > should he fail to notice.. or be somewhat dense.
> 
> Yeah, if those dudes don't stare at dmesg, that note doesn't bring us
> whit.
> 
> Alternatively, we could do
> 
> 	add_taint(TAINT_HOTPLUG_POUNDER)
> 
> when the rate is exceeded...
> 
> I'd rather like to slow it down for a second, though, if it doesn't hurt
> any sensible use cases in doing so.

Actually, you should just taint as soon as someone tries to use cpu hotplug if 
it does not work. 

I wonder what happens on those multi-core android phones. They suspend multiple 
times a second. Do they do cpu hotplugs at that point?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
