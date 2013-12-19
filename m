Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3LSSGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:06:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3LSSGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:06:30 -0500
Message-ID: <52B33567.9060205@zytor.com>
Date: Thu, 19 Dec 2013 10:05:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power regression
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com> <20131219122257.GC11279@gmail.com> <52B316FF.50906@zytor.com> <20131219160210.GA28426@gmail.com> <52B31B21.6010901@zytor.com> <20131219162136.GM16438@laptop.programming.kicks-ass.net> <52B323BE.7090108@zytor.com> <20131219170741.GB30382@gmail.com> <20131219172535.GN16438@laptop.programming.kicks-ass.net> <20131219173629.GJ2480@laptop.programming.kicks-ass.net>
In-Reply-To: <20131219173629.GJ2480@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:36 AM, Peter Zijlstra wrote:
> On Thu, Dec 19, 2013 at 06:25:35PM +0100, Peter Zijlstra wrote:
>> That said, I would find it very strange indeed if a CLFLUSH doesn't also
>> flush the store buffer.
> 
> OK, it explicitly states it does not do that and you indeed need an
> mfence before the clflush.
> 

So, MONITOR is defined to be ordered as a load, which I think should be
adequate, but I really wonder if we should have mfence on both sides of
clflush.  This now is up to 9 bytes, and perhaps pushing it a bit with
how much we would be willing to patch out.

On the other hand - the CLFLUSH seems to have worked well enough by
itself, and this is all probabilistic anyway, so perhaps we should just
leave the naked CLFLUSH in and not worry about it unless measurements
say otherwise?

	-hpa

