Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaEDSkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 14:40:22 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63574 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEDSkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 14:40:21 -0400
Date: Sun, 4 May 2014 20:40:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
Message-ID: <20140504184016.GA16438@gmail.com>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
 <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
 <CALCETrX8wCxRj9=F7_pM_SKdSxSYttMyLZKAWTy9HurAmtfC2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX8wCxRj9=F7_pM_SKdSxSYttMyLZKAWTy9HurAmtfC2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> > That said, regular *device* interrupts do often return to kernel 
> > mode (the idle loop in particular), so if you have any way to 
> > measure that, that might be interesting, and might show some of 
> > the same advantages.
> 
> I can try something awful involving measuring latency of 
> hardware-timed packets on a SolarFlare card, but I'll have 
> calibration issues.  I suppose I could see if 'ping' gets faster.  
> In general, this will speed up interrupts that wake userspace from 
> idle by about 100ns on my box, since it's presumably the same size 
> and the speedup per loop in my silly benchmark.

To simulate high rate device IRQ you can generate very high frequency 
lapic IRQs by using hrtimers, that's generating a ton of per CPU lapic 
IRQs.

Thanks,

	Ingo
