Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaEDT7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:59:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:19926 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaEDT7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,983,1389772800"; 
   d="scan'208";a="427453598"
Message-ID: <53669C32.2010601@intel.com>
Date: Sun, 04 May 2014 12:59:46 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net> <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CALCETrX8wCxRj9=F7_pM_SKdSxSYttMyLZKAWTy9HurAmtfC2w@mail.gmail.com> <20140504184016.GA16438@gmail.com>
In-Reply-To: <20140504184016.GA16438@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 11:40 AM, Ingo Molnar wrote:
> 
> * Andy Lutomirski <luto@amacapital.net> wrote:
> 
>>> That said, regular *device* interrupts do often return to kernel 
>>> mode (the idle loop in particular), so if you have any way to 
>>> measure that, that might be interesting, and might show some of 
>>> the same advantages.
>>
>> I can try something awful involving measuring latency of 
>> hardware-timed packets on a SolarFlare card, but I'll have 
>> calibration issues.  I suppose I could see if 'ping' gets faster.  
>> In general, this will speed up interrupts that wake userspace from 
>> idle by about 100ns on my box, since it's presumably the same size 
>> and the speedup per loop in my silly benchmark.
> 
> To simulate high rate device IRQ you can generate very high frequency 
> lapic IRQs by using hrtimers, that's generating a ton of per CPU lapic 
> IRQs.
> 

The bigger question is if that helps in measuring the actual latency.
It should get more data points, to be sure.

Maybe let userspace sit in a tight loop doing RDTSC, and look for data
points too far apart to have been uninterrupted?

	-hpa


