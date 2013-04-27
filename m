Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3D0SiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 14:38:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39789 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3D0SiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:38:03 -0400
Date: Sat, 27 Apr 2013 20:38:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org,
        eduardo.valentin@ti.com
Subject: Re: [PATCH] ACPI thermal: do not always return
 THERMAL_TREND_RAISING for active trip points
Message-ID: <20130427183800.GA8929@amd.pavel.ucw.cz>
References: <1366967993-3812-1-git-send-email-rui.zhang@intel.com>
 <20130427102346.GA30588@amd.pavel.ucw.cz>
 <1367065950.2128.11.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367065950.2128.11.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Is that even right algoritm?
> > 
> sorry the changelog is not clear enough here.
> I should say,
> "keep the fan on when the temperature is raising"
> "turn off the fan when the temperature is dropping"
> 
> > Assume I'm running at very cold room, lets say -10C. Assume idle CPU
> > will hover around 30C with no fan, or hover around 10C with fan
> > running, trip point being 50C.
> > 
> > You _could_ leave fan off until 50C, having silent, passively cooled
> > system.
> > 
> > What it will do instead is annoyingly pulse fan at 10C.
> > 
> First, fan will never spins on if the temperature never hits 50C.
> 
> let's see how ACPI 3.0 fan (just have on and off state) is supposed to
> work after overheat.
> 1. temperature goes above 50C
> 2. Fan starts to spin.
> 3. a) if temperature goes higher (if possible), fan keeps on.
>    b) if temperature drops, but still above 50C. the fan keeps on.
>    c) if temperature drops below 50C, the last temperature is above 50C,
> thus the fan is turned off.
>    d) if the temperature goes higher again, the fan will not spin on
> until the temperature is higher than the trip point (50C) again.

So the fan is spinning iff the temperature is over threshold, right?

> is this behavior what you want?

That's better, yes. Even better would be if it had some hysteresis:
turn the fan on at threshold temperature, but turn it off only if it
drops below temperature-5C, or if it is below threshold for 1 minute.

Thanks,
      	    		       	     	      		      Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
