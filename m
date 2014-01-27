Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaA0EtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:49:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41751 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbaA0EtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:49:19 -0500
Message-ID: <52E5E508.3060203@zytor.com>
Date: Sun, 26 Jan 2014 20:48:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>	<20140127002255.GA10323@ZenIV.linux.org.uk> <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
In-Reply-To: <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 08:32 PM, Linus Torvalds wrote:
> On Sun, Jan 26, 2014 at 4:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Umm...  Can't uprobe_notify_resume() modify regs as well?
> 
> Probably.
> 
> .. and on the other hand, we should actually be able to use 'sysret'
> for signal handling on x86-64, because while sysret destroys %rcx and
> doesn't allow for returning to odd modes, for calling a signal handler
> I don't think we really care..
> 

Yes, it is the fourth argument register, but we only have three
arguments to a signal handler.  I had to think about that one.

>> While we
>> are at it, when we start using the same thing on 32bit kernels, we'll
>> need to watch out for execve() - the reason why start_thread() sets
>> TIF_NOTIFY_RESUME is to force us away from sysexit path.  IIRC, vm86
>> is another thing to watch out for (same reasons).
> 
> Yes, the 32-bit code I didn't want to touch, partly because I no
> longer have a test-case. And it does end up having some more
> interesting cases.

That is one way to put it.  However, this code is incredibly ugly and
getting it cleaned up would really, really help, of course.

	-hpa


