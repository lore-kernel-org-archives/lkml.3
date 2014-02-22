Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaBVW2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:28:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBVW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:28:22 -0500
Date: Sat, 22 Feb 2014 23:28:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Message-ID: <20140222222819.GA20490@amd.pavel.ucw.cz>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <20140222103840.GH21483@n2100.arm.linux.org.uk>
 <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > return from the finisher will always be interpreted as an abort rather
> > than success (because the state has to be unwound.)
> > 
> > This is the only way to get a zero return from cpu_suspend().
> 
> Yes, that's the only reason why this code is jumping to cpu_resume, since
> all it is needed is to snapshot the CPU context and by the time the
> finisher is called that's done. Wanted to say that soft reboot is not
> useful (cache flushing and resume with MMU off), but what you are saying
> is correct. We might be saving swsusp_save return value in a global
> variable and just return from the finisher, but that's horrible and
> given the amount of time it takes to snapshot the image to disk the
> cost of this soft reboot will be dwarfed by that.

I feel bad for the "global variable" trick on x86, and if you can
avoid it, please do!

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
