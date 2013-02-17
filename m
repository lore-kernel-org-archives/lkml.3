Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3BQVyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 16:54:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3BQVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 16:54:53 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MPEKn9ueenIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zGjexpQmzOwA:10 a=CjxXgO3LAAAA:8 a=kADjIXcFrCjqV-ybU7YA:9 a=PUjeQqilurYA:10 a=rC2wZJ5BpNYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361138089.23152.141.camel@gandalf.local.home>
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
Date: Sun, 17 Feb 2013 16:54:49 -0500
In-Reply-To: <1361085245.28353.3.camel@marge.simpson.net>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1361031150.23152.133.camel@gandalf.local.home>
	 <1361082363.6088.21.camel@marge.simpson.net>
	 <1361085245.28353.3.camel@marge.simpson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-17 at 08:14 +0100, Mike Galbraith wrote:

> (And puts a dent in x264 ultrafast)
> 
> +SD_BALANCE_NEWIDLE
> encoded 600 frames, 425.04 fps, 22132.71 kb/s
> encoded 600 frames, 416.07 fps, 22132.71 kb/s
> encoded 600 frames, 417.49 fps, 22132.71 kb/s
> encoded 600 frames, 420.65 fps, 22132.71 kb/s
> encoded 600 frames, 425.55 fps, 22132.71 kb/s
> encoded 600 frames, 425.58 fps, 22132.71 kb/s
> encoded 600 frames, 426.18 fps, 22132.71 kb/s
> encoded 600 frames, 424.21 fps, 22132.71 kb/s
> encoded 600 frames, 422.20 fps, 22132.71 kb/s
> encoded 600 frames, 423.15 fps, 22132.71 kb/s
> 
> -SD_BALANCE_NEWIDLE
> encoded 600 frames, 378.52 fps, 22132.71 kb/s
> encoded 600 frames, 378.75 fps, 22132.71 kb/s
> encoded 600 frames, 378.20 fps, 22132.71 kb/s
> encoded 600 frames, 372.54 fps, 22132.71 kb/s
> encoded 600 frames, 366.69 fps, 22132.71 kb/s
> encoded 600 frames, 378.46 fps, 22132.71 kb/s
> encoded 600 frames, 379.89 fps, 22132.71 kb/s
> encoded 600 frames, 382.25 fps, 22132.71 kb/s
> encoded 600 frames, 384.10 fps, 22132.71 kb/s
> encoded 600 frames, 375.24 fps, 22132.71 kb/s

What about my last patch? The one that avoids idle_balance() if the
previous task was in a task_uninterruptible state. That one gave the
same performance increase that removing idle_balance() did on my box.

-- Steve



