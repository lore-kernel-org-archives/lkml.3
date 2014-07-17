Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaGQNUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:20:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:35857 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQNUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:20:33 -0400
Date: Thu, 17 Jul 2014 15:19:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Mark Brown <broonie@kernel.org>, Clemens Ladisch <clemens@ladisch.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        John Stultz <john.stultz@linaro.org>
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
In-Reply-To: <53C78B54.5070102@linaro.org>
Message-ID: <alpine.DEB.2.10.1407171519360.24854@nanos>
References: <alpine.DEB.2.10.1407161151450.24854@nanos> <53C6633D.9080905@ladisch.de> <20140716123727.GA19379@twins.programming.kicks-ass.net> <53C68943.2060003@ladisch.de> <20140716150010.GA4951@sirena.org.uk> <53C78B54.5070102@linaro.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Daniel Thompson wrote:

> On 16/07/14 16:00, Mark Brown wrote:
> > On Wed, Jul 16, 2014 at 04:16:35PM +0200, Clemens Ladisch wrote:
> >> Peter Zijlstra wrote:
> >>> On Wed, Jul 16, 2014 at 01:34:21PM +0200, Clemens Ladisch wrote:
> > 
> >>>> The purpose is to get a stable clock, i.e., to avoid clock rate changes
> >>>> caused by NTP corrections.
> > 
> >>> That's maybe half an answer; what do you need that for?
> > 
> >> According to the original report, "for applications which need to
> >> synchronise with external timebases such as broadcast TV applications".
> >> Such external clocks are not synchronous with any available clocksource,
> >> so proper resampling requires that the (relative) rate of the two clocks
> >> (sender and playback device) is measured accurately.
> > 
> >> (I don't have numbers for the errors caused by NTP adjustments.  Daniel?)
> > 
> > Right, the goal is to get a clock which is guaranteed to never have any
> > adjustments that might cause discontinuities or rate changes applied to
> > it.  My understanding is that the users are already doing their own rate
> > matching and it's much more important to them to get a stable clock than
> > it is to get a clock at a specific nominal rate, and given the set top
> > box applications I expect they also need this from very soon after boot.
> 
> We are trying to match rates with a broadcast device that "shouts" the
> current time many times per second (MPEG transport stream PCR packets).
> These packets are timestamped on arrival with a local clock and the
> resulting data is used to recover the broadcast clock. However due to
> variable transmission delay of the packets we require very long
> control loops to extract any useful information from this data (varies
> between five minutes and half and hour).
> 
> An NTP rate correction can change the rate of CLOCK_MONOTONIC
> sufficiently to confuse our clock recovery algorithms so we use
> CLOCK_MONOTONIC_RAW as the master view of time.
> 
> Both audio and video must be presented synchronized to the recovered
> broadcast clock which in practice this means comparing them to
> CLOCK_MONOTONIC_RAW and doing some maths.
> 
> In is, of course, possible to convert ALSA's CLOCK_MONOTONIC
> timestamps into CLOCK_MONOTONIC_RAW values so we can compare ALSA time
> to the broadcast clock. In fact its not even that hard compared to the
> other time conversions we have to do. Nevertheless it is a redundant
> conversion and adds an extra dimension to a problem that only just fits
> in most craniums ;-)

Thanks for the explanation!

       tglx
