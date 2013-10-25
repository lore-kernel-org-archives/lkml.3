Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3JYKon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:44:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60461 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3JYKom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:44:42 -0400
Date: Fri, 25 Oct 2013 11:44:35 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 01/11] Export __smp_call_function_single()
Message-ID: <20131025104435.GC6285@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-2-git-send-email-axboe@kernel.dk>
 <20131025102154.GB3481@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025102154.GB3481@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25 2013, Ingo Molnar wrote:
> 
> * Jens Axboe <axboe@kernel.dk> wrote:
> 
> > The blk-mq core and the blk-mq null driver uses it.
> > 
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > ---
> >  kernel/smp.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 0564571..9de461e 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -340,6 +340,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *csd,
> >  	}
> >  	put_cpu();
> >  }
> > +EXPORT_SYMBOL(__smp_call_function_single);
> 
> I agree with exporting it to in-kernel users, but I'd prefer a _GPL 
> export for newly exported symbols that are for in-kernel use.

Agree, it should be _GPL. I will update the patch. Can I add your
acked-by?

-- 
Jens Axboe

