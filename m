Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaFWGym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:54:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaFWGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:54:39 -0400
Date: Mon, 23 Jun 2014 08:54:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        vgupta@synopsys.com
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
Message-ID: <20140623065423.GE19860@laptop.programming.kicks-ass.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:21:13AM -0700, Davidlohr Bueso wrote:
> diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
> index d99f9b3..8e1bf6b 100644
> --- a/arch/arc/include/asm/processor.h
> +++ b/arch/arc/include/asm/processor.h
> @@ -62,6 +62,8 @@ unsigned long thread_saved_pc(struct task_struct *t);
>  #define cpu_relax()	do { } while (0)
>  #endif
>  
> +#define arch_cpu_relax() cpu_relax()
> +
>  #define copy_segments(tsk, mm)      do { } while (0)
>  #define release_segments(mm)        do { } while (0)

I'm not at all sure that cpu_relax() definition ARC has is valid. We
rely on cpu_relax() being at least a barrier() all over the place, and
it doesn't need to be SMP only. You can have a UP wait loop waiting for
an interrupt for example.

Vineet?
