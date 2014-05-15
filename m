Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaEOPqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:46:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:33488 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbaEOPqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1060,1389772800"; 
   d="scan'208";a="512239088"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Thu, 15 May 2014 08:47:12 -0700
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
CC: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Message-ID: <CF9A2F18.90E61%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <537407ED.8050606@zytor.com>
 <CF999CD6.90A93%dvhart@linux.intel.com>
 <5374C54B.7040408@gmail.com>
In-Reply-To: <5374C54B.7040408@gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, 6:46, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
wrote:

>On 05/15/2014 07:21 AM, Darren Hart wrote:
>> On 5/14/14, 17:18, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> 
>>> On 05/14/2014 09:18 AM, Darren Hart wrote:
>>>>
>>>> However, unless I'm sorely mistaken, the larger problem is that glibc
>>>> removed the futex() call entirely, so these man pages don't describe
>>>> something users even have access to anymore. I had to revert to
>>>>calling
>>>> the syscalls directly in the futextest test suite because of this:
>>>>
>>>>
>>>> 
>>>>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/i
>>>>nc
>>>> lu
>>>> de/futextest.h#n67
>>>>
>>>
>>> This really comes down to the fact that we should have a libinux which
>>> contains the basic system call wrapper machinery for Linux specific
>>> things and nothing else.
>>>
>>> syscall(3) is toxic and breaks randomly on some platforms.
>> 
>> Peter Z and I have had a good time discussing this in the past.... And
>> here it is again. :-)
>
>People have a number of times noted that there are problems
>with syscall(), but I'm not knowledgeable on the details.
>I'd happily take a patch to the man page (which, for historical
>reasons, is actually syscall(2)) that explains the the problems
>(and ideally notes those platforms where there are no problems).


>From my perspective, a named interface with specific documented interfaces
is far more usable than a vargs direct syscall. That just leaves all kinds
of room for error - which of course is why we all write our own wrappers
in our apps rather than use it directly... If we all do it, it seems to me
that is a strong indicator we should provide it in some kind of common
library. Maybe that's libc... Maybe that's libnix...
-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



