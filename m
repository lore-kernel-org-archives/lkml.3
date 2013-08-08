Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064Ab3HHNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:33:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47488 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3HHNdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:33:55 -0400
Date: Thu, 8 Aug 2013 09:40:08 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Subject: Re: perf,arm -- another (different) fuzzer oops
In-Reply-To: <20130808121337.GC18724@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1308080931570.22047@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org> <alpine.DEB.2.10.1308072227060.16962@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1308072251210.20629@vincent-weaver-1.um.maine.edu> <20130808121337.GC18724@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013, Will Deacon wrote:

> On the flip side, the good news is that we know the problem is there. We're
> probably generating interrupts at some horrendous rate for the lock-up....
> are you running your fuzzer as root?

No, I'm running the fuzzer as a regular user.

> Also, is your fuzzer available somewhere? I could take it for a spin on some
> different architectures if you like.

Yes:

  git clone https://github.com/deater/perf_event_tests.git

and it's in the "fuzzer" subdirectory.  I think I've committed all of the 
ARM related patches.

To run the tool it's just "./perf_fuzzer" and away you go.  There's a lot 
of other tools for generating and analyzing fuzzer syscall traces but 
unfortunately they're not very user-friendly yet.


As for other architectures (at least ARM) in addition to the pandaboard I 
also have a beagleboard and a cortex-A15 chromebook.  The challenge is 
always getting recent Linus-git kernels running on the things.

I also have a raspberry-pi.  I've successfully accessed the perf counters 
on that by reading the low-level registers directly with a kernel 
modulue.  There's no perf driver because the PMU interrupt isn't hooked 
up.  I've been meaning to get perf support going by making things 
periodically polled rather than interrupt driven: has anybody looked into 
doing that yet?

Vince

