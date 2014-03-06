Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaCFOfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:35:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46089 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaCFOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:35:44 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1403061530470.18573@ionos.tec.linutronix.de>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <87ob1jbgtg.fsf@rasmusvillemoes.dk> <20140306133450.GL9987@twins.programming.kicks-ass.net> <87k3c7bfvn.fsf@rasmusvillemoes.dk> <20140306140243.GN9987@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1403061530470.18573@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Mar 2014 06:34:32 -0800
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Khalid Aziz <khalid.aziz@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Message-ID: <2924bdbb-a7a2-4863-9b71-14d2d159f803@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The no checking is omitting access_ok(), no? Either way, disabling page faults have to be done explicitly.

On March 6, 2014 6:33:04 AM PST, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>
>On Thu, 6 Mar 2014, Peter Zijlstra wrote:
>
>> On Thu, Mar 06, 2014 at 02:45:00PM +0100, Rasmus Villemoes wrote:
>> > Peter Zijlstra <peterz@infradead.org> writes:
>> > 
>> > > On Thu, Mar 06, 2014 at 02:24:43PM +0100, Rasmus Villemoes wrote:
>> > >> Is it possible to implement non-sleeping versions of
>{get,put}_user()?
>> > >
>> > > __{get,put}_user()
>> > 
>> > Huh?
>> > 
>> > arch/x86/include/asm/uaccess.h:
>> > 
>> > /**
>> >  * __get_user: - Get a simple variable from user space, with less
>checking.
>> >  * @x:   Variable to store result.
>> >  * @ptr: Source address, in user space.
>> >  *
>> >  * Context: User context only.  This function may sleep.
>> > 
>> > What am I missing?
>> 
>> __get_user() -> __get_user_nocheck() -> __get_user_size() ->
>__get_user_asm()
>> 
>> And __get_user_asm() seems to generate the required .fixup section
>for
>> this to work in pagefault_disable() context.
>
>Well, it still might sleep if you're using it in page fault enabled
>context. So the documentation of that function sucks.
>
>Thanks,
>
>	tglx

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
