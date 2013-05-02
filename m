Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3EBHe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:34:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43750 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3EBHeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:34:25 -0400
Date: Thu, 2 May 2013 09:32:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130502073252.GG7521@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
 <20130501090718.GA28253@dyad.programming.kicks-ass.net>
 <m261z3uipb.fsf@firstfloor.org>
 <20130501111219.GF28253@dyad.programming.kicks-ass.net>
 <CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
 <20130501191342.GH17814@two.firstfloor.org>
 <CABPqkBS7FxoT1fioe_VdBMcLAdZtfwRiMmSMocSY5TB3QAyPQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS7FxoT1fioe_VdBMcLAdZtfwRiMmSMocSY5TB3QAyPQQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:21:55PM +0200, Stephane Eranian wrote:
> On Wed, May 1, 2013 at 9:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> Unfortunately, Andi's patch fails to correct the problem though
> >> it is the right approach. As he said, the problem is unfortunately
> >
> > perf stat -a / record -a / top will work.
> >
> But it does not for perf stat -a. Look at my example, run it on your machine.


Since nobody seems interested in explaining the exact nature of the hardware
failure I think the best thing we can do is simply blacklist these events.

Broken hardware is broken after all -- we should jump through too many hoops
pretending its not.
