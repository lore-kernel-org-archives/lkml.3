Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaI2MHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:07:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35017 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaI2MH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:07:27 -0400
Date: Mon, 29 Sep 2014 14:07:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] fork.c: copy_process(): fix cleanup WRT
 perf_event_free_task()
Message-ID: <20140929120722.GA11943@gmail.com>
References: <20140926210652.GA27199@erable>
 <20140927180725.GA15594@redhat.com>
 <20140929101201.GE5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929101201.GE5430@worktop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: perf: Fix perf bug in fork()
> 
> Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
> calling perf_event_free_task() when failing sched_fork() we will not yet
> have done the memset() on ->perf_event_ctxp[] and will therefore try and
> 'free' the inherited contexts, which are still in use by the parent
> process. This is bad..
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Could this fix a couple of fuzzer triggered perf crashes perhaps?

Thanks,

	Ingo
