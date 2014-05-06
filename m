Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaEFUlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:41:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:34663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaEFUlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:41:20 -0400
Date: Tue, 6 May 2014 22:41:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Preeti Murthy <preeti.lkml@gmail.com>, umgwanakikbuti@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, george.mccollister@gmail.com,
        ktkhai@parallels.com, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140506204117.GR17778@laptop.programming.kicks-ass.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
 <1399011219.5233.55.camel@marge.simpson.net>
 <53633B81.1080403@redhat.com>
 <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com>
 <53663565.9080306@redhat.com>
 <20140506132516.GJ11096@twins.programming.kicks-ass.net>
 <5369442B.9010505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5369442B.9010505@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:20:59PM -0400, Rik van Riel wrote:
> On 05/06/2014 09:25 AM, Peter Zijlstra wrote:
> > On Sun, May 04, 2014 at 08:41:09AM -0400, Rik van Riel wrote:
> >> Even on 8-node DL980 systems, the NUMA distance in the
> >> SLIT table is less than RECLAIM_DISTANCE, and we will
> >> do wake_affine across the entire system.
> > 
> > Yeah, so the problem is that (AFAIK) ACPI doesn't actually specify a
> > metric for the SLIT distance. This (in as far as BIOS people would care
> > to stick to specs anyhow) has lead to the 'fun' situation where BIOS
> > engineers tweak SLIT table values to make OSes behave as they thing it
> > should.
> > 
> > So if the BIOS engineer finds that this system should have <
> > RECLAIM_DISTANCE it will simply make the table such that the max SLIT
> > value is below that.
> > 
> > And yes, I've seen this :-(
> 
> It appears to be the case on the vast majority of the NUMA
> systems that are actually in use.
> 
> To me, this suggests that we should probably deal with it.

What we could do is redefine this distance in hops, that'll force them
to lie more blatantly and actually miss represent the topology.
