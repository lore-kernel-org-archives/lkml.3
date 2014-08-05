Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaHEXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:13:41 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39312 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaHEXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140803173031.GQ18735@two.firstfloor.org>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	<8738dm9t4z.fsf@tassilo.jf.intel.com>
	<1406532289.5133.223.camel@marge.simpson.net>
	<CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	<20140803173031.GQ18735@two.firstfloor.org>
Date: Tue, 5 Aug 2014 16:13:38 -0700
Message-ID: <CA+80gGb5gJax=+1eg=f3pMkxXU0NBWDCkxEtBV7iekgcd1QcTg@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 10:30 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> (One example might be virtual machine that runs guest operating system that is
>> not paravirtualized or can be paravirtualized only to a limited extent. The VM
>> might guess that preemption of VCPU thread that is processing events such as
>> IPI interrupts, clock interrupts or certain device interrupts is likely to
>> cause overall performance degradation due to other VCPUs spinning for an IPI
>> response or spinning waiting for a spinlock, and thought the general kinds of
>> these dependencies may be foreseen, but actual dependency chains between VCPUs
>> cannot be established at run time.)
>
> PAUSE loop exiting (PLE) can handle it in limited fashion on VMs
> even without paravirtualization.


The key word is "limited". Sometimes the use of PLE can help to a limited
indeed (see below) extent, and sometimes it can even be counter-productive,
which in turn can also be mitigated (http://lwn.net/Articles/424960/) but again
in a limited fashion.

This indeed is similar to the spinlock example discussed in the previous
message. Similarly to PI/PE, the use of PLE and other spin-loop detection
techniques is about trying to minimize the cost of after-
inopportune-preemption actions to whatever (unavoidably limited, that's the key
thing) extent they can be minimized, whereas priority protection is about the
avoidance of incurring these costs in the first place.

And then, x86 VMs is just one use case, whereas there are others with no PLE or
similar recourses. DPRIO as a matter of fact happened to be conceived within
the context of the project running legacy non-x86 OS that does not have pause
in the loops, and the loops are scattered throughout the pre-existing binary
code in huge numbers and are not pragmatically instrumentable. But this just
exemplifies a general pattern of having to do with concurrency in a component
being driven from or driving another component that is for practical purposes
"set in stone" (3rd party, legacy, out of the scope of the project etc.)

- Sergey
