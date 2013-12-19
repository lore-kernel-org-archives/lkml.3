Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3LSQvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:51:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33748 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab3LSQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:51:21 -0500
Message-ID: <52B323BE.7090108@zytor.com>
Date: Thu, 19 Dec 2013 08:50:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power regression
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com> <20131219122257.GC11279@gmail.com> <52B316FF.50906@zytor.com> <20131219160210.GA28426@gmail.com> <52B31B21.6010901@zytor.com> <20131219162136.GM16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131219162136.GM16438@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 08:21 AM, Peter Zijlstra wrote:
> 
> What's that mb for?
> 

It already exists in mwait_idle_with_hints(); I just moved it into this
common function.  It is a bit odd, I have to admit; it seems like it
should be *before* the monitor (and possibly we should have one after
the CLFLUSH as well?)

> Also, can you please merge:
> 
>   http://marc.info/?l=linux-kernel&m=138685838420632
> 
> Thomas said he would pick up that series, but seems to have gone missing
> the past week or so.
> 

We need to get the immediate regression fixed.
