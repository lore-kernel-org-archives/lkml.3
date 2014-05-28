Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaE1IAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:00:19 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:57563 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaE1IAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:00:15 -0400
Date: Wed, 28 May 2014 09:59:45 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Johan Hovold <jhovold@gmail.com>,
        dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Smythies <dsmythies@telus.net>, Yuyang Du <yuyang.du@intel.com>,
        Stratos Karafotis <stratosk@semaphore.gr>
Subject: Re: Performance regression in v3.14
Message-ID: <20140528075945.GA21705@localhost>
References: <20140506163559.GA5308@localhost>
 <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
 <536A3EE9.5050409@intel.com>
 <20140521090051.GO21412@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521090051.GO21412@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: Greg, Doug, Stratos, Yuyang ]

On Wed, May 21, 2014 at 11:00:51AM +0200, Johan Hovold wrote:
> On Wed, May 07, 2014 at 07:10:49AM -0700, Dirk Brandewie wrote:
> > On 05/06/2014 10:40 PM, Viresh Kumar wrote:
> > > Cc'ing Dirk who is taking care of intel-pstate driver.
> > >
> > 
> > Thanks Viresh I had seen this thread.
> > 
> > I am looking into it
> 
> Any updates on this, Dirk? 3.14 is still basically unusable with the
> intel_pstate driver.
> 
> Any fixes or workarounds posted elsewhere that I can apply in the
> meantime?

Another week and still no reply, Dirk?

I tried applying your (rejected) patch "intel_pstate: Remove C0
tracking" posted here:

	https://lkml.org/lkml/2014/5/8/574

to v3.14.4 and it fixes the problem as expected.

So we have a commit fcb6a15c2e7e ("intel_pstate: Take core C0 time into
account for core busy calculation") that went into v3.14-rc2 (and was
even marked for *stable*) that first broke Greg KH's system:

	https://lkml.org/lkml/2014/2/19/626

That was apparently fixed by e66c17683746 ("intel_pstate: Change
busy calculation to use fixed point math."), but still left v3.14
basically unusable for lower-intensity workloads such as my
bash-completion example and other reported regressions:

	https://bugzilla.kernel.org/show_bug.cgi?id=75121

Sure there may be issues with v3.13 not hitting the lowest frequencies
but at least the system was *usable*.

In my opinion there's really no other option than to restore the 3.13
behaviour by effectively reverting fcb6a15c2e7e ("intel_pstate: Take
core C0 time into account for core busy calculation") until you have
figured out a way to take C0 into account without breaking things too
badly.

Johan
