Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbbAZOlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:41:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56931 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753808AbbAZOlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:41:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
Date: Mon, 26 Jan 2015 16:04:05 +0100
Message-ID: <4090311.nIPlPBbS65@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1501261531250.5526@nanos>
References: <54866625.8010406@linux.intel.com> <2076277.JWdUtd56Il@vostro.rjw.lan> <alpine.DEB.2.11.1501261531250.5526@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2015 03:34:22 PM Thomas Gleixner wrote:
> On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:
> > On Monday, January 26, 2015 03:24:27 PM Thomas Gleixner wrote:
> > > On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:
> > > > On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> > > > > The only remaining issue might be a NMI calling into
> > > > > ktime_get_mono_fast_ns() before timekeeping is resumed. Its probably a
> > > > > non issue on x86/tsc, but it might be a problem on other platforms
> > > > > which turn off devices, clocks, It's not rocket science to prevent
> > > > > that.
> > > > 
> > > > I don't see any users of ktime_get_mono_fast_ns() at all, unless some non-trivial
> > > > macros are involved.  At least grepping for it only returns the definition,
> > > > declarations and the line in trace.c.
> > > 
> > > You can trace in NMI and perf is going to use ktime_get_mono_fast_ns()
> > > eventually as well.
> > 
> > So I'm not sure how to intercept that to be honest.  Any hints?
> 
> If we suspend timekeeping we can make the fast timekeeper point at a
> dummy readout function which returns the time at suspend, if the clock
> source does not resume automagically.
> 
> As I said TSC should be a non issue, but other stuff might be. We
> could make it conditional on CLOCK_SOURCE_SUSPEND_NONSTOP perhaps.

OK, thanks!

Rafael

