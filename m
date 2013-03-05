Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3CEEcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:32:19 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:41549 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758759Ab3CEEcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:32:18 -0500
Date: Mon, 4 Mar 2013 21:32:03 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
Message-ID: <20130305043203.GA26678@obsidianresearch.com>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
 <20130305035302.GA5239@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305035302.GA5239@feng-snb>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 11:53:02AM +0800, Feng Tang wrote:

> > // Drops some small precision along the way but is simple..
> > static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
> >                                           cycle_t cycles)
> > {
> >     u64 max = U64_MAX/cc->mult;
> >     u64 num = cycles/max;
> >     u64 result = num * ((max * cc->mult) >> cc->shift);
> >     return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
> > }
> 
> Your way is surely more accurate, if maintainers are ok with adding
> the new API, I will use it.

Okay, give it a good look though, I only wrote it out in email, never
tested it :)

> > You may want to also CC the maintainers of all the ARM subsystems that
> > use read_persistent_clock and check with them to ensure this new
> > interface will let them migrate their implementations as well.
> 
> Maybe I didn't get it well, my patches didn't change the
> read_persistent_clock(), but inject a new way of counting suspended
> time. It should have no functional changes to existing platforms.

Right, your patches are fine stand alone.

The ARM case of plat-omap/counter_32k.c would ideally be converted to
use your new API though, that is what I ment about involving them.

I'm not sure about mach-tegra/timer.c though - it seems to be using a
counter as well but somehow sharing registers with the RTC?

Regards,
Jason
