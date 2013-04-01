Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3DAAIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 20:08:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14323 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3DAAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 20:08:30 -0400
X-Spam-Score: -100.7
Message-ID: <5158CFDF.4060700@asianux.com>
Date: Mon, 01 Apr 2013 08:07:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] posix-timers: Correctly get dying task time sample
 in posix_cpu_timer_schedule()
References: <1364649331-30940-1-git-send-email-fweisbec@gmail.com> <1364649331-30940-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1364649331-30940-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê03ÔÂ30ÈÕ 21:15, Frederic Weisbecker wrote:
> In order to arm the next timer to schedule, we take a sample of the
> current process or thread cputime.
> 
> If the task is dying though, we don't arm anything but we
> cache the remaining timer expiration delta for further reads.
> 
> Something similar is performed in posix_cpu_timer_get() but
> here we forget to take the process wide cputime sample
> before caching it.
> 
> As a result we are storing random stack content, leading
> every further reads of that timer to return junk values.
> 
> Fix this by taking the appropriate sample in the case of
> process wide timers.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Chen Gang <gang.chen@asianux.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Chen Gang <gang.chen@asianux.com>
> ---

  thank you for mark me as reported by, although I reported too late
(Andrew Morton is the first reporter).

  next, I should continue to try to find another issues about kernel.

  :-)

-- 
Chen Gang

Asianux Corporation
