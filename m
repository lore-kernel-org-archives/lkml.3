Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3BRPXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:23:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3BRPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:23:11 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MPEKn9ueenIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zGjexpQmzOwA:10 a=3-v-330or6qoVSpEtHYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361200989.23152.150.camel@gandalf.local.home>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Mon, 18 Feb 2013 10:23:09 -0500
In-Reply-To: <1361158953.14352.17.camel@marge.simpson.net>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1361031150.23152.133.camel@gandalf.local.home>
	 <1361082363.6088.21.camel@marge.simpson.net>
	 <1361085245.28353.3.camel@marge.simpson.net>
	 <1361138089.23152.141.camel@gandalf.local.home>
	 <1361158953.14352.17.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 04:42 +0100, Mike Galbraith wrote:
> On Sun, 2013-02-17 at 16:54 -0500, Steven Rostedt wrote:
> > On Sun, 2013-02-17 at 08:14 +0100, Mike Galbraith wrote:
> > 
> > > (And puts a dent in x264 ultrafast) 
>  
> > What about my last patch? The one that avoids idle_balance() if the
> > previous task was in a task_uninterruptible state. That one gave the
> > same performance increase that removing idle_balance() did on my box.
> 
> I didn't try it, figuring it was pretty much the same as turning it off,
> but just did.  Patch (-typo) has no effect on either x264 or hackbench
> (surely will for -rt, but rt tasks here aren't sent to burn in rt hell).

So it had no effect to your tests? That's actually good, as if it has a
positive effect on some workloads and no effect on others, that's still
a net win.

-- Steve


