Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3D2Wm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:42:29 -0400
Received: from mail-gg0-f181.google.com ([209.85.161.181]:60127 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab3D2Wm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:42:28 -0400
Message-ID: <517EF751.2050600@gmail.com>
Date: Mon, 29 Apr 2013 18:42:25 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its corresponding
 clock
References: <1365184746.874.103.camel@Wailaba2>  <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>  <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>  <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>  <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>  <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>  <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>  <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>  <517DFFE9.4050808@gmail.com> <1367255407.8833.4.camel@Wailaba2>  <517EB45D.60007@gmail.com> <1367259631.8833.27.camel@Wailaba2>  <517EBC71.4070709@gmail.com> <1367261667.8833.39.camel@Wailaba2>  <517EC582.8090400@gmail.com> <1367270454.8833.45.camel@Wailaba2>
In-Reply-To: <1367270454.8833.45.camel@Wailaba2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> tick lost doesn't occur an issue. because glibc only test posix conformance and
>> posix allow inacculacy. In other words, timer must not run faster than real clock.
>> but lost and makes slower are accepted in the test.
>>
> What is lost isn't cputimer tick. They are accounted
> account_group_exec_runtime(). What is lost it is what is added to
> curr->sum_exec_runtime. Thus making the thread group clock running
> slower than the cputimer.
> 
> Please spend some time reading the code and less time writing e-mails.
> 
> Read the code of release_task() and where it is called in do_exit().
> 
> Once it is done, it should be clear to you.

After several grepping, I may got your point. Guys, sig->sum_sched_runtime is gathered
in __exit_signal, not release_task() nor do_exit().

So, I'm now convinced your patch is correct. Even though the comments is terribuly misleading.



