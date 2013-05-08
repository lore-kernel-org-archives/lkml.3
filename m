Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3EHSOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:47 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:45993 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3EHSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:45 -0400
Message-ID: <518A9614.2010805@tilera.com>
Date: Wed, 8 May 2013 14:14:44 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
References: <20130505110351.GA4768@gmail.com>	<CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>	<20130505212511.GC3659@linux.vnet.ibm.com>	<20130506092537.GA8879@gmail.com>	<20130506153517.GA3501@linux.vnet.ibm.com> <CA+55aFxYRDZvisB7iZ5a-bcp5_2pkvcC9Opk6=yJtjfK57EWTw@mail.gmail.com>
In-Reply-To: <CA+55aFxYRDZvisB7iZ5a-bcp5_2pkvcC9Opk6=yJtjfK57EWTw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/2013 3:32 PM, Linus Torvalds wrote:
> On Mon, May 6, 2013 at 8:35 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>>>
>>> I think Linus might have referred to my 'future plans' entry:
> 
> Indeed. I feel that HPC is entirely irrelevant to anybody,
> *especially* HPC benchmarks. In real life, even HPC doesn't tend to
> have the nice behavior their much-touted benchmarks have.
> 
> So as long as the NOHZ is for HPC-style loads, then quite frankly, I
> don't feel it is worth it. The _only_ thing that makes it worth it is
> that "future plans" part where it would actually help real loads.

The work is very relevant to a lot of the actual customer applications
that Tilera chips are sold into: running very low latency userspace
applications that handle packet processing (or, to a lesser extent,
video frame processing).  For packet processing in particular, you really
want to be able to guarantee that you can set up a core handling packets
in userspace and get NO INTERRUPTS at all, ever.  If you do get an
interrupt, you end up dropping a bunch of packets on the floor.

We are still using code I developed internally for this (for the curious,
in my dataplane branch on kernel.org), but I expect in the relatively near
future we will be trying to switch to the NOHZ stuff instead.  I'm
really pleased to see it start getting merged up.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
