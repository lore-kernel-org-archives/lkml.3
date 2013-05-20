Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3ETJ7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:59:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46358 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3ETJ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:59:06 -0400
Date: Mon, 20 May 2013 11:59:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <robherring2@gmail.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] ARM: delay: print dummy values for bogomips
Message-ID: <20130520095904.GA7279@amd.pavel.ucw.cz>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <1367602547-19322-2-git-send-email-will.deacon@arm.com>
 <20130506231554.GB16801@amd.pavel.ucw.cz>
 <5188B8B2.5030601@arm.com>
 <alpine.LFD.2.03.1305141547180.31158@syhkavp.arg>
 <CAL_Jsq+Q5UMGo3J+vKKCRU+w4Kj0YN0exs7UCWTEOxmFjWfo3g@mail.gmail.com>
 <alpine.LFD.2.03.1305141945160.31158@syhkavp.arg>
 <20130515090103.GA12907@mudshark.cambridge.arm.com>
 <20130515114737.GA7900@amd.pavel.ucw.cz>
 <alpine.LFD.2.03.1305150830540.31158@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1305150830540.31158@syhkavp.arg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > In fact, I just tried it and at least my linaro filesystem seems happy
> > > enough.
> > 
> > Would it be too much work to simply put the field back with the right
> > value? We don't have to get it as precise as we used to, that should
> > make slowdown minimum.
> 
> There is simply no right value.  And whenever there is a value, people 
> read too much into it.

You are right that there is no right value. But there are many _wrong_
values.

Take a look at CPU temperature. There's no right value there, either,
as CPU has different temperatures at different places. Displaying
heatsink temp +5C is probably ok. Displaying case temperature or
compile time constant is not.

Now, bogoMIPS is supposed to be instructions per second. Measure
instructions per second, and you have acceptable value to display. Put
back code from previous version, and you have acceptable value to
display.

"0", "1" or value from Kconfig is _not_ acceptable value.

Maybe bogomips should not have been exposed in /proc in the first
place, but it is too late now. "No regressions".

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
