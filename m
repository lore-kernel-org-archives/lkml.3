Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaEOTjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:39:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:37877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaEOTjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1061,1389772800"; 
   d="scan'208";a="512372060"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Thu, 15 May 2014 12:38:29 -0700
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
Message-ID: <CF9A658E.91322%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
 <20140515163004.GB7959@rei.Home>
 <CF9A3A75.90F40%dvhart@linux.intel.com>
 <20140515190529.GA8887@rei.Home>
In-Reply-To: <20140515190529.GA8887@rei.Home>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, 12:05, "chrubis@suse.cz" <chrubis@suse.cz> wrote:

>Hi!
>> >> I've used LTP in the past (quite a bit), and I felt there was some
>> >> advantage to keeping futextest independent.
>> >
>> >What advantages did you have in mind?
>> 
>> Not CVS was a big one at the time ;-)
>> 
>> OK, I don't mean to be disparaging here... But since you asked, back in
>> '09 LTP had some test quality issues and I felt I could maintain
>>futextest
>> to a higher bar independently.
>
>To be honest LTP was one of the messiest codebases I've seen and it was
>hacked up by mostly clueless people (there were even tests with race
>conditions that were carefully disabled in a way that was not easy to
>see). It took me months to get to a state where it compiled fine on
>major distributions.
>
>Today we still have quite a bit of legacy code that needs to be cleaned
>up, however that gets better every day.
>
>And most of the testcases are pretty stable, etc. unfortunatelly LTP has
>a bad reputation which is lot harder to fix than the code itself.
>
>> >> Perhaps things have changed enough since then (~2009 era) that we
>> >> should reconsider.
>> >
>> >I've been working on LTP for a about three years now and we happen to
>>do
>> >quite a lot in that time. The most visible changes would be more proper
>> >development practices (git, proper build system, code review, LKML
>> >coding style, documentation, ...) and also huge number of fixes. Now we
>> >are trying to catch up in coverage too.
>> >
>> >> We can discuss the pros/cons there if you like.
>> >
>> >I would love to :).
>> 
>> Does LTP need to own the code, or can it incorporate existing projects
>>and
>> a sort of aggregator?
>
>That is possible as well but not optimal. This approach would need a
>wrapper script to convert the test exit values to be LTP compatible.
>
>> How much LTP harness type code needs to be used?
>
>Not much.
>
>For this complexity of tests you would just need to call the tst_resm()
>interface to report success/failure and, at the end of the test,
>tst_exit() to return the stored overall test status.
>
>And ideally call the standard option parsing code and call the test in
>standard loop so that the test can take advantage of standard options as
>number of iterations to run, etc.
>
>Have a look at:
>
>https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines
>
>there is simple test example as well as description of the interfaces.


Thanks Cyril,

I'll follow up with you in a couple weeks most likely. I have some urgent
things that will be taking all my time and then some until then. Feel free
to poke me though if I lose track of it :-)

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



