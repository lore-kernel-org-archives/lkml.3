Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935153Ab3DJMCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:02:34 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:57512 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3DJMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:02:33 -0400
Date: Wed, 10 Apr 2013 14:02:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] cputime: remove scaling
Message-ID: <20130410120228.GC8083@gmail.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
 <1364489605-5443-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364489605-5443-5-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Scaling cputime cause problems, bunch of them was fixed, but still is possible 
> to hit multiplication overflow issue, which make {u,s}time values incorrect. 
> This problem has no good solution in kernel.

Wasn't 128-bit math a solution to the overflow problems? 128-bit math isn't nice, 
but at least for multiplication it's defensible.

> This patch remove scaling code and export raw values of {u,t}ime . Procps 
> programs can use newly introduced sum_exec_runtime to find out precisely 
> calculated process cpu time and scale utime, stime values accordingly.
> 
> Unfortunately times(2) syscall has no such option.
> 
> This change affect kernels compiled without CONFIG_VIRT_CPU_ACCOUNTING_*.

So, the concern here is that 'top hiding' code can now hide again. It's also that 
we are not really solving the problem, we are pushing it to user-space - which in 
the best case gets updated to solve the problem in some similar fashion - and in 
the worst case does not get updated or does it in a buggy way.

So while user-space has it a bit easier because it can do floating point math, is 
there really no workable solution to the current kernel side integer overflow bug? 
I really prefer robust kernel side accounting/instrumentation.

Thanks,

	Ingo
