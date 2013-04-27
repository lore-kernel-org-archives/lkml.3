Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3D0BvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 21:51:20 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59830 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751108Ab3D0BvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 21:51:19 -0400
Message-ID: <1367027476.7911.60.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Apr 2013 21:51:16 -0400
In-Reply-To: <517AD0AE.1030404@gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 15:08 -0400, KOSAKI Motohiro wrote:
> > I need to add that I can only confirm that to be true with
> > sum_exec_runtime.
> > 
> > To affirm it to be true for stime and utime would require more
> > investigation. I didn't look them at all. I was only concerned with
> > sum_exec_runtime.
> > 
> > I will prepare a v2 of the patch accounting all the feedbacks that I
> > received from KOSAKI Motohiro, Frederic Weisbecker and Peter Zijlstra
> > and send it back here for further discussion.
> > 
> > Thank you very much all!
> 
> Do you mean your utime test case still failure? If you share your test-case, 
> I'm going to look at your issue too.
> 
Sure with pleasure. My testcase is glibc-2.17/rt/tst-cputimer1.c

That being said, it strictly test CPUCLOCK_SCHED timers. Hence my focus
when modifying the code was strictly on sum_exec_runtime.

If utime and stime components of cputimer are moving faster than their
associated clock, this is something that I did not address.


