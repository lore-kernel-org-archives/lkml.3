Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbaDIPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:10:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45671 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514AbaDIPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:10:09 -0400
Date: Wed, 9 Apr 2014 17:09:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Noonan <steven@uplinklabs.net>,
        Mel Gorman <mgorman@suse.de>, Cyrill Gorcunov <gorcunov@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
Message-ID: <20140409150935.GC10526@twins.programming.kicks-ass.net>
References: <20140407182854.GH7292@suse.de>
 <5342FC0E.9080701@zytor.com>
 <20140407193646.GC23983@moon>
 <5342FFB0.6010501@zytor.com>
 <20140407212535.GJ7292@suse.de>
 <CAKbGBLhsWKVYnBqR0ZJ2kfaF_h=XAYkjq=v3RLoRBDkF_w=6ag@mail.gmail.com>
 <e9801da2-3aa4-4c23-9a64-90c890b9ebbc@email.android.com>
 <CAKbGBLjO7pneg_5nXcRXK-9iToZvPkJVZ=AQBfaZkZjU9iN2BA@mail.gmail.com>
 <5344631D.1050203@zytor.com>
 <20140409150448.GE5860@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409150448.GE5860@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:04:48AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 08, 2014 at 01:59:09PM -0700, H. Peter Anvin wrote:
> > On 04/08/2014 01:51 PM, Steven Noonan wrote:
> > > On Tue, Apr 8, 2014 at 8:16 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > >> <snark>
> > >>
> > >> Of course, it would also be preferable if Amazon (or anything else) didn't need Xen PV :(
> > > 
> > > Well Amazon doesn't expose NUMA on PV, only on HVM guests.
> > > 
> > 
> > Yes, but Amazon is one of the main things keeping Xen PV alive as far as
> > I can tell, which means the support gets built in, and so on.
> 
> Taking the snarkiness aside, the issue here is that even on guests
> without NUMA exposed the problem shows up. That is the 'mknuma' are
> still being called even if the guest topology is not NUMA!
> 
> Which brings a question - why isn't the mknuma and its friends gatted by
> an jump_label machinery or such?
> 
> Mel, any particular reasons why it couldn't be done this way?

Hmm,. I thought we disabled all that when there was only the 1 node. All
this should be driven from task_tick_numa() which only gets called when
numabalancing_enabled, and that _should_ be false when nr_nodes == 1.
