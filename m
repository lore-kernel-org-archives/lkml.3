Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaDNIVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:21:05 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:65016 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaDNITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:19:35 -0400
Date: Mon, 14 Apr 2014 10:19:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, chegu_vinod@hp.com, mgorman@suse.de,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/3] sched,numa: retry placement more frequently when
 misplaced
Message-ID: <20140414081930.GA18528@gmail.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
 <1397235629-16328-3-git-send-email-riel@redhat.com>
 <1397238417.7113.29.camel@joe-AO722>
 <53482E77.7030802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53482E77.7030802@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 04/11/2014 01:46 PM, Joe Perches wrote:
> > On Fri, 2014-04-11 at 13:00 -0400, riel@redhat.com wrote:
> >> This patch reduces the interval at which migration is retried,
> >> when the task's numa_scan_period is small.
> > 
> > More style trivia and a question.

[...]

> > 	interval = min_t(unsigned long, HZ,
> > 			 msecs_to_jiffies(p->numa_scan_period) / 16);
> 
> That's what I had before, but spilling things over across multiple 
> lines like that didn't exactly help readability.

Joe, the low quality 'trivial reviews' you are doing are becoming a 
burden on people, so could you please either exclude arch/x86/ from 
your "waste other people's time" email filter; or improve the quality 
(and relevance) of your replies, so that you consider not just 
trivialities but the bigger picture as well?

Most people who enter kernel development start with trivial patches 
and within a few months of learning the kernel ropes rise up to more 
serious, more useful topics.

This process is constructive: it gives the Linux kernel a constant 
influx of useful cleanup patches, while it also gives newbies a 
smooth, easy path of entry into kernel hacking. Thus we maintainers 
are friendly and inclusive to newbie-originated cleanups.

But the problem is that you remained stuck at the cleanup level for 
about a decade, and you don't seem to be willing to improve ...

The thing is, as of today there's hundreds of thousands of 'cleanups' 
flagged by checkpatch.pl on the latest kernel tree. That body of "easy 
changes" is more than enough to keep newbies busy, but had all those 
lines of code been commented on for trivialities by cleanup-only 
people like you - forcing another 1 million often bogus commits into 
the development process - it would have bogged Linux down to a 
standstill and would have prevented _real_ review from occuring.

Every time you comment on a patch, considering only trivialities, you 
risk crowding out some real reviewer who might mistakenly believe when 
seeing a reply to the email thread that the patch in question got a 
thorough review...

So what you are doing is starting to become net destructive:

 - it is crowding out real review

 - the 'solutions' you suggest often result in worse code

 - you burden contributors and maintainers with make-work 'cleanups'
   created by a professional cleanup bureaucrat.

Stop doing these low-substance reviews! Do some real reviews (which 
can very much include trivial comments as well), or try to improve 
your review abilities by writing real kernel code.

Thanks,

	Ingo
