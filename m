Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaJ0Ho0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:44:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:44246 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJ0HoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:44:25 -0400
Date: Mon, 27 Oct 2014 08:44:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141027074419.GE10501@worktop.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
 <20141024153656.GM12706@worktop.programming.kicks-ass.net>
 <544DE5CF.9040501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544DE5CF.9040501@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:27:27PM +0800, Li, Aubrey wrote:
> >> +static void freezer_suspend_tk(int cpu)
> >>  {
> >> +	if (tick_do_timer_cpu != cpu)
> >> +		return;
> >> +
> > 
> > I had a note here that this might be broken for clocksource drivers that
> > have suspend/resume methods. You seem to have 'lost' that note, is that
> > because you found it isn't a problem?
> > 
> I don't see it's a problem as long as we do not refer the clock source
> before it resumes. But I think my testing didn't cover that case that
> clock source drivers have suspend/resume methods. Can you please give
> more details what do you worry about?

I can't seem to recall :/ Maybe I conflated clocksource and clockevents
and figured we'd need to run the clocksource suspend callback on each
cpu.
