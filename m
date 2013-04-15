Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3DOL1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:27:01 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53265 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3DOL07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:26:59 -0400
Date: Mon, 15 Apr 2013 13:26:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Allow setting period 1
Message-ID: <20130415112655.GA26300@gmail.com>
References: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
 <20130410125808.GC12978@gmail.com>
 <20130410133157.GG22166@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410133157.GG22166@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Wed, Apr 10, 2013 at 02:58:08PM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > I had some requests for setting period 1, so that every event of something
> > > is caught.  To my knowledge there is no limit to 1 on Intel hardware.
> > > Just remove the check for minimum 2
> > > 
> > > If specific CPUs have problems we can black list them.
> > 
> > How have you tested this? The commit that added this quirk mentions very high perf 
> > load triggering badness unless this quirk is added.
> 
> Profiling a couple of simple loads on Westmere and IvyBridge: mostly AIM7 and 
> kernel builds. You can get throttling of course, but no excessive load.
> 
> The original quirk was done long ago before the modern event throttling 
> infrastructure may have been completely in place, right?

The failure IIRC wasn't about throttling or not, it was about extreme profiling 
(lots of copies of perf record, perf top, perf stat running in parallel, mixed -a 
and workload-local options), eventually resulting in a messed up PMU.

So before we can remove that a similar test should be repeated and made sure that 
no badness happens, on a wide enough range of systems.

Thanks,

	Ingo
