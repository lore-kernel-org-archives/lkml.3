Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3DZEkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:40:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:41123 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751090Ab3DZEkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:40:14 -0400
Message-ID: <1366951210.7911.28.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Apr 2013 00:40:10 -0400
In-Reply-To: <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 11:08 -0700, KOSAKI Motohiro wrote:
> On Fri, Apr 19, 2013 at 10:38 AM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
> >> I feel we are hitting the same issue than this patch:
> >> https://lkml.org/lkml/2013/4/5/116
> >>
> >> I'm adding Kosaki in Cc, who proposed roughly the same fix.
> >
> > Thanks to CCing. I'm now sitting LSF and I can't read whole tons emails.
> > However the fix is definitely same and I definitely agree this approach.
> >
> > thank you.
> 
> And if I understand correctly, update_gt_cputime() is no longer
> necessary after this patch because time never makes backward.
> 
> What do you think?

Kosaki, I would tend to say that what you propose is exact. After having
added the task deltas I was puzzled to see the cputimer still moving
faster than the process clock. I was seeing it with the the help of
printk statement inside update_gt_cputime().

After nailing down the last remaining cause of that inside sched/core.c,
I have never seen after the cputimer being in advance.


