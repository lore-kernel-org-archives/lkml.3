Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3DOQfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:35:33 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:39588 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3DOQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:35:32 -0400
Date: Mon, 15 Apr 2013 12:39:05 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: forcing instructions event to run on Fixed Counter 0
In-Reply-To: <CAMsRxfLUvRw-PUxgX_909PLCFtqqnKO3iiZ8Wvc5DHGAPp3yxA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1304151231490.17281@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1304151205140.17281@vincent-weaver-1.um.maine.edu> <CAMsRxfLUvRw-PUxgX_909PLCFtqqnKO3iiZ8Wvc5DHGAPp3yxA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Stephane Eranian wrote:

> Never heard of that problem. I know there was another problem due to leaking
> during priv level transitions. It would be take a few instr or cycles to realize
> you were not in user level any more when doing event:u.
> 
> Interrupt should impact fixed and generic counters the same way.

Some people inside Intel were reproducing my "deterministic event" work 
and they informed me of this issue.

> Are you sure that the 5th event stayed in fixed counter 0 all along?

No, but is there any way to enforce that currently using perf?

The results are about what I'd expect.  The generic instructions:u
events are overcounting by roughly 20,008 for page faults (as expected)
and 650 for hardware interrupts (also as expected) wheras the 
Fixed Counter 0 event is overcounting 10,000 (for page faults?) and 
undercounting a bit possibly due to a supposedly known issue involving
the counts for rep-prefixed string instructions that apparently only 
happens on Fixed Counter 0.
 
> > $ perf stat -e instructions:u,instructions:u,instructions:u,instructions:u,instructions:u ./retired_instr.all.x86_64
> > ...
> >  Performance counter stats for './retired_instr.all.x86_64':
> >
> >        227,010,687 instructions:u            #    0.00  insns per cycle
> >        227,010,687 instructions:u            #    0.00  insns per cycle
> >        227,010,687 instructions:u            #    0.00  insns per cycle
> >        227,010,687 instructions:u            #    0.00  insns per cycle
> >        227,000,723 instructions:u            #    0.00  insns per cycle
> >
> >        1.902648316 seconds time elapsed


Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
