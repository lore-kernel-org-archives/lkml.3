Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3EIJUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:20:19 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42450 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3EIJUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:20:17 -0400
Date: Thu, 9 May 2013 11:20:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_preempt running flat out on idle desktop.
Message-ID: <20130509092013.GA21620@gmail.com>
References: <20130508203042.GA18895@redhat.com>
 <20130508205258.GN3648@linux.vnet.ibm.com>
 <20130508205633.GB18895@redhat.com>
 <CAFTL4hws3q2k9rc0Trh5v9DxNVT575GfV0wZFRg6k7htF+VSyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hws3q2k9rc0Trh5v9DxNVT575GfV0wZFRg6k7htF+VSyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/5/8 Dave Jones <davej@redhat.com>:
> > On Wed, May 08, 2013 at 01:52:58PM -0700, Paul E. McKenney wrote:
> >  > On Wed, May 08, 2013 at 04:30:42PM -0400, Dave Jones wrote:
> >
> >  > >   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
> >  > >    10 root      20   0     0    0    0 S 200.0  0.0 185301:36 rcu_preempt
> >  > >   553 root      20   0  268m  76m 6764 S 200.0  2.6 144579:53 Xorg
> >  > >  1199 root      20   0     0    0    0 S 200.0  0.0 306:17.85 kworker/1:0
> >  > >   501 root      20   0     0    0    0 S 200.0  0.0   4471:03 kworker/0:2
> >  > >    12 root      20   0     0    0    0 S 200.0  0.0  67277:16 rcuop/1
> >  > >  1237 davej     20   0  535m  15m 8484 S 200.0  0.5   3645:16 Terminal
> >  > >   859 davej     20   0  117m 3036 1336 S 200.0  0.1   1986:55 htop
> >  > >
> >  > > There are a lot of processes allegedly using "200%" of CPU time, a handful
> >  > > in the "196%" range, and then a bunch at 0.
> >  >
> >  > Yow!!!  185301 minutes is 128 days, which is a truly impressive amount of
> >  > CPU time to accumulate in a few short hours.
> 
> Right, Ingo has reported something about strange high numbers in top
> too. I need to investigate that.

For CPU-intense loops I have seen a small anomaly with "slightly higher 
CPU usage numbers" - sometimes going to 101% or so but still converging to 
around 99.9% in the long run.

The 200% bug pasted by Dave here seems to be very big and seems to affect 
all tasks not just true CPU-loopers. So I'd suggest reproducing and fixing 
Dave's bug first - that might fix the small anomaly I've seen.

Thanks,

	Ingo
