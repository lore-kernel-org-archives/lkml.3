Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3KUXpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:45:38 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33806 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KUXpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <528E94E2.3080102@ahsoftware.de>
References: <52803E5D.3050109@mentor.com>
	<52851395.3010306@mentor.com>
	<67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
	<CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
	<528E2E8E.8080004@ahsoftware.de>
	<CA+55aFyNZun07BLoD2KQFT7cN1xsiQ2gE6hYwRvOGa3tCap4CQ@mail.gmail.com>
	<528E94E2.3080102@ahsoftware.de>
Date: Thu, 21 Nov 2013 15:45:35 -0800
Message-ID: <CANxoKds1iLpXK0yb1qW_Z4tLSRccrf69nYUV7mLSJBMwSrjwmQ@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
From: Luis Lozano <llozano@google.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we need a reproducer. Without this we may all be going on the
wrong path. This whole conversation started on an *assumption* that
some accesses were being reordered.

evidence of the reorder or reproducer please?

Luis


On Thu, Nov 21, 2013 at 3:18 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>
> Am 21.11.2013 23:32, schrieb Linus Torvalds:
>
>> On Thu, Nov 21, 2013 at 8:02 AM, Alexander Holler <holler@ahsoftware.de>
>> wrote:
>
>
>> The bug is not that gcc can re-order or combine the accesses to "sp".
>> WE WANT THAT TO HAPPEN.
>
>
> Sure, and I don't disagree on that.
>
>
>>
>> The bug is *outside* that "current_thread_info()" macro/inline
>> function. It's the *dereference* of the pointer that gcc re-orders.
>> AND THAT IS WRONG.
>>
>> Gcc seems to mess up the alias analysis, and decide that the
>> deferences cannot alias. Which is wrong. They clearly *can* alias,
>> exactly because the value of "sp & ~(THREAD_SIZE - 1)" ends up having
>> the same value all the time.
>
>
> Sorry, that I still disagree.
>
> I try to describe it more clearly why I still think that the problem might
> be because of that const declaration.
>
> (...)
>
> foobar1 = current_thread_info() __attribute_const__ {
>         return sp->somewhere_local;
> }
>
> (...)
>
> foobar2 = current_thread_info() __attribute_const__ {
>         return sp->somewhere_local;
> }
>
> So, even if sp is the same in both cases, that const states that wherever sp
> points to is local to current_thread_info(), so it can't be the same for
> both cases.
>
> Regards,
>
> Alexander Holler



-- 

Luis A. Lozano | Software Engineer | llozano@google.com | +1 (408)431-5164
