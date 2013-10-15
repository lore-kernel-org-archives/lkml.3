Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3JONSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:18:16 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:56381 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab3JONSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:18:09 -0400
Date: Tue, 15 Oct 2013 15:18:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] perf tools: use ansi versions of asm and volatile
Message-ID: <20131015131805.GE2402@gmail.com>
References: <1381835960-22900-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381835960-22900-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> asm and volatile are provided for backward compatibility; use the ansi
> versions __asm__ and __volatile__.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  Thanks to Peter for pointing out the instances I missed.
> 
>  tools/perf/arch/powerpc/util/header.c |  2 +-
>  tools/perf/perf.h                     | 54 +++++++++++++++++------------------
>  tools/perf/tests/perf-time-to-tsc.c   |  2 +-
>  tools/perf/tests/rdpmc.c              |  6 ++--
>  4 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
> index 2f7073d..4b0a302 100644
> --- a/tools/perf/arch/powerpc/util/header.c
> +++ b/tools/perf/arch/powerpc/util/header.c
> @@ -10,7 +10,7 @@
>  #define __stringify(x)          __stringify_1(x)
>  
>  #define mfspr(rn)       ({unsigned long rval; \
> -			 asm volatile("mfspr %0," __stringify(rn) \
> +			 __asm__ __volatile__("mfspr %0," __stringify(rn) \

The thing is, there's a few thousand more 'nonstandard' cases in the 
kernel source:

  comet:~/tip> git grep -w 'asm.*(' | wc -l
  2617

  comet:~/tip> git grep -w '__asm__.*(' | wc -l
  2376

So unless all of them are converted I'm not convinced at all about the 
necessity of this change.

It's not like GCC will (be able to) reuse 'asm' and 'volatile' for some 
other purpose anytime soon (read: within decades, or ever), so this change 
brings not much useful to the table AFAICS.

I personally find 'asm volatile' plenty readable, the underscores don't 
add any extra info.

Thanks,

	Ingo
