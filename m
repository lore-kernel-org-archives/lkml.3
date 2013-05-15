Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3EOLrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:47:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37778 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3EOLrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:47:39 -0400
Date: Wed, 15 May 2013 13:47:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Rob Herring <robherring2@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
Message-ID: <20130515114737.GA7900@amd.pavel.ucw.cz>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <1367602547-19322-2-git-send-email-will.deacon@arm.com>
 <20130506231554.GB16801@amd.pavel.ucw.cz>
 <5188B8B2.5030601@arm.com>
 <alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
 <CAL_Jsq+Q5UMGo3J+vKKCRU+w4Kj0YN0exs7UCWTEOxmFjWfo3g@mail.gmail.com>
 <alpine.LFD.2.03.1305141945160.31158@syhkavp.arg>
 <20130515090103.GA12907@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090103.GA12907@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-05-15 10:01:03, Will Deacon wrote:
> Hi Nico,
> 
> On Wed, May 15, 2013 at 12:56:51AM +0100, Nicolas Pitre wrote:
> > On Tue, 14 May 2013, Rob Herring wrote:
> > > On Tue, May 14, 2013 at 2:54 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > > > Waitaminute... Didn't you just claim this would be an ABI break?
> > > >
> > > > So if no application can be found, where is the ABI breakage?
> > > 
> > > lscpu
> > > 
> > > But that is already "broken" on ARM because x86 uses "bogomips" and
> > > ARM uses "BogoMIPS". 
> > 
> > So basically it won't be any more broken if the field disappears 
> > entirely, right?
> 
> It's not these sort of tools I was worried about. I was thinking about the
> possibility of badly written parsers which want some other field from
> cpuinfo, but use the bogomips line for context. Do these applications exist?
> No idea.

Yes, they do. bogomips is not nearly as bogus as you imply.

See

http://www.clifton.nl/index.html?bogomips.html

https://play.google.com/store/apps/details?id=com.securiteinfo.android.bogomips&hl=en

> My second (less stupid) version of the patch prints "not reported". I'd be
> happy to remove the line altogether if people get behind the decision though.
> In fact, I just tried it and at least my linaro filesystem seems happy
> enough.

Would it be too much work to simply put the field back with the right
value? We don't have to get it as precise as we used to, that should
make slowdown minimum.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
