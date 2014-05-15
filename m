Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaEOQNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:13:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:3617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaEOQNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:13:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1060,1389772800"; 
   d="scan'208";a="512255051"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Thu, 15 May 2014 09:14:05 -0700
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: <chrubis@suse.cz>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Message-ID: <CF9A3521.90ECC%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
In-Reply-To: <20140515152834.GA6926@rei.Home>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, 8:28, "chrubis@suse.cz" <chrubis@suse.cz> wrote:

>Hi!
>> 
>> However, unless I'm sorely mistaken, the larger problem is that glibc
>> removed the futex() call entirely, so these man pages don't describe
>> something users even have access to anymore. I had to revert to calling
>> the syscalls directly in the futextest test suite because of this:
>> 
>> 
>>http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inc
>>lu
>
>So there actually exists some tests for futexes, I've been asked if we
>have these as a LTP[1] maintainer several times.
>
>Are these tests executed regulary as a part of some automated framework?
>If not it would make sense to port them to LTP (looking at the code that
>would be quite easy task) and get them executed by several QA
>departments for free. What do you think?
>
>[1] http://linux-test-project.github.io/

I've used LTP in the past (quite a bit), and I felt there was some
advantage to keeping futextest independent. Perhaps things have changed
enough since then (~2009 era) that we should reconsider. We can discuss
the pros/cons there if you like. I have agreed to move the performance
related tests over to perf, and Davidlohr has added some other such tests
to perf. Trinity now covers the planned fuzz testing for futexes (very
well... Obviously) so that idea will be dropped, leaving pure functional
tests in futextest.

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



