Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJVHfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:35:15 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:54547 "EHLO
	homiemail-a5.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbaJVHfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:35:08 -0400
Message-ID: <1413963289.26628.3.camel@linux-t7sj.site>
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 22 Oct 2014 00:34:49 -0700
In-Reply-To: <20141020215633.717315139@infradead.org>
References: <20141020215633.717315139@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 23:56 +0200, Peter Zijlstra wrote:
> Hi,
> 
> I figured I'd give my 2010 speculative fault series another spin:
> 
>   https://lkml.org/lkml/2010/1/4/257
> 
> Since then I think many of the outstanding issues have changed sufficiently to
> warrant another go. In particular Al Viro's delayed fput seems to have made it
> entirely 'normal' to delay fput(). Lai Jiangshan's SRCU rewrite provided us
> with call_srcu() and my preemptible mmu_gather removed the TLB flushes from
> under the PTL.
> 
> The code needs way more attention but builds a kernel and runs the
> micro-benchmark so I figured I'd post it before sinking more time into it.
> 
> I realize the micro-bench is about as good as it gets for this series and not
> very realistic otherwise, but I think it does show the potential benefit the
> approach has.
> 
> (patches go against .18-rc1+)

I think patch 2/6 is borken:

error: patch failed: mm/memory.c:2025
error: mm/memory.c: patch does not apply

and related, as you mention, I would very much welcome having the
introduction of 'struct faut_env' as a separate cleanup patch. May I
suggest renaming it to fault_cxt?

Thanks,
Davidlohr

