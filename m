Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaEOPmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:42:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:2110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaEOPml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:42:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1060,1389772800"; 
   d="scan'208";a="512236888"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Thu, 15 May 2014 08:43:04 -0700
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>
CC: <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Message-ID: <CF9A2E34.90E56%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <20140515081357.GC11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140515081357.GC11096@twins.programming.kicks-ass.net>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, 1:13, "Peter Zijlstra" <peterz@infradead.org> wrote:

>On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
>> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
>> >> However, unless I'm sorely mistaken, the larger problem is that glibc
>> >> removed the futex() call entirely, so these man pages don't describe
>> > 
>> > I don't think futex() ever was in glibc--that's by design, and
>> > completely understandable: no user-space application would want to
>> > directly use futex(). (BTW, I mispoke in my earlier mail when I said I
>> > wanted documentation suitable for "writers of library functions" -- I
>> > meant suitable for "writers of *C library*".)
>> 
>> I fully agree with Michael here.
>> 
>> The futex() syscall was never exposed to userspace specifically because
>> it was an interface we did not want to support forever with a stable
>>ABI.
>> The futex() syscall is an implementation detail that is shared between
>> the kernel and the writers of core runtimes for Linux.
>
>That ship has sailed.. for one we must always support old glibc which
>uses the futex() syscall, and secondly there are known other programs
>that actually use the futex syscall.
>
>So that's really a non-argument, we're hard tied to the ABI.

Indeed. This is specifically why FUTEX_REQUEUE still exists (despite it's
bugs) when only FUTEX_CMP_REQUEUE should ever be used in new programs.


-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



