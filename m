Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3LSVGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:06:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab3LSVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:06:35 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131219181812.GC32508@gmail.com>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com> <20131219122257.GC11279@gmail.com> <52B316FF.50906@zytor.com> <20131219160210.GA28426@gmail.com> <52B31B21.6010901@zytor.com> <20131219162136.GM16438@laptop.programming.kicks-ass.net> <52B323BE.7090108@zytor.com> <20131219170741.GB30382@gmail.com> <20131219172535.GN16438@laptop.programming.kicks-ass.net> <20131219175037.GK2480@laptop.programming.kicks-ass.net> <20131219181812.GC32508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power regression
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 19 Dec 2013 13:05:43 -0800
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Message-ID: <44cc7c3a-7114-4f37-a844-77e552dbc7aa@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLFLUSH is only (guaranteed to be) ordered with respect to MFENCE according to the SDM.

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, Dec 19, 2013 at 06:25:35PM +0100, Peter Zijlstra wrote:
>> > On Thu, Dec 19, 2013 at 06:07:41PM +0100, Ingo Molnar wrote:
>> > > Likewise, having a barrier before the MONITOR looks sensible as
>well. 
>> > 
>> > I again have to disagree, one would expect monitor to flush all
>that is
>> > required to start the monitor -- and it actually does so. As is
>> > testified by this extra CLFLUSH being called a bug workaround.
>> 
>> SDM states that MONITOR is ordered like a LOAD, and a LOAD cannot 
>> pass a previous STORE to the same address.
>
>Yes ... but you could argue that CLFLUSH is neither a load nor a 
>store, it's a _cache sync_ operation, with its special ordering 
>properties.
>
>> That said; there's enough holes in there to swim a titanic through, 
>> seeing how MONITOR stares at an entire cacheline and LOAD/STORE 
>> order is specified on location, whatever that means.
>
>I think assuming that MONITOR is ordered as a load or better is a 
>pretty safe one (and in fact the Intel documentation seems to say so) 
>- I'd say MONITOR is in micro-code and essentially snoops on cache 
>events on that specific cache line, and loads the cache line on a 
>snoop hit?
>
>Btw., what state is the cache line after a MONITOR instruction, is it 
>loaded as shared, or as excusive? (exclusive would probably be better 
>for performance.)
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
