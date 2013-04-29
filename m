Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab3D2SUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:20:34 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52997 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758437Ab3D2SUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:20:33 -0400
Message-ID: <1367259631.8833.27.camel@Wailaba2>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 14:20:31 -0400
In-Reply-To: <517EB45D.60007@gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>
	 <517DFFE9.4050808@gmail.com> <1367255407.8833.4.camel@Wailaba2>
	 <517EB45D.60007@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> >> I'm confused. glibc's rt/tst-cputimer1 doesn't have thread exiting code. I have
> >> no seen any issue in this accounting.
> > 
> > glibc launch a helper thread to receive timer signal and will also
> > create a new thread upon signal reception when a timer is created with
> > sigev_notify = SIGEV_THREAD;
> > 
> > please see:
> > 
> > glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_create.c
> > glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_routines.c
> 
> I know. I taled thread exiting. not thread creating. And, as far as I can see, only test sig1 can fail,
> not thr[12].
> 
Apart from glibc helper thread, the threads created for handling timer
firing all do exit immediatly as soon as user callback returns.

I count 12 thread exits during tst-cputimer1 execution. The errors do
add up hence you're more likely to see errors after 2.5 sec and up from
start of execution. I have seen sig1, thr[12] fails. I see no reason why
one could not fail.


