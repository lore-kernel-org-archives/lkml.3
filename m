Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400Ab3DKP1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:27:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38665 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936073Ab3DKP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:27:04 -0400
Date: Thu, 11 Apr 2013 17:26:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] posix-timers: Correctly get dying task time sample
 in posix_cpu_timer_schedule()
Message-ID: <20130411152656.GG15699@somewhere>
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com>
 <1364649331-30940-2-git-send-email-fweisbec@gmail.com>
 <5158CFDF.4060700@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5158CFDF.4060700@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 08:07:59AM +0800, Chen Gang wrote:
> On 2013年03月30日 21:15, Frederic Weisbecker wrote:
> > In order to arm the next timer to schedule, we take a sample of the
> > current process or thread cputime.
> > 
> > If the task is dying though, we don't arm anything but we
> > cache the remaining timer expiration delta for further reads.
> > 
> > Something similar is performed in posix_cpu_timer_get() but
> > here we forget to take the process wide cputime sample
> > before caching it.
> > 
> > As a result we are storing random stack content, leading
> > every further reads of that timer to return junk values.
> > 
> > Fix this by taking the appropriate sample in the case of
> > process wide timers.
> > 
> > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> > Reported-by: Chen Gang <gang.chen@asianux.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Chen Gang <gang.chen@asianux.com>
> > ---
> 
>   thank you for mark me as reported by, although I reported too late
> (Andrew Morton is the first reporter).

Bug reporters simply deserve to be credited, no sorting is required ;)

> 
>   next, I should continue to try to find another issues about kernel.

I encourage you to do so :)

Thanks.
