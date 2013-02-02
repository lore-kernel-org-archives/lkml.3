Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3BBDOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:14:41 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:62698 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3BBDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:14:40 -0500
Subject: Re: [PATCH] IRQ CORE: irq_work_queue function return value not
 used.
From: anish kumar <anish198519851985@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org
In-Reply-To: <CAFTL4hx8JRft0Xy02vRdOQptNcTA1TxhB+x_pzRphMxqUDgBMA@mail.gmail.com>
References: <1351933030-1462-1-git-send-email-anish198519851985@gmail.com>
	 <CAFTL4hx8JRft0Xy02vRdOQptNcTA1TxhB+x_pzRphMxqUDgBMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Feb 2013 08:44:24 +0530
Message-ID: <1359774864.1666.30.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 17:24 +0100, Frederic Weisbecker wrote:
> 2012/11/3 anish kumar <anish198519851985@gmail.com>:
> > From: anish kumar <anish198519851985@gmail.com>
> >
> > As no one is using the return value of irq_work_queue function
> > it is better to just make it void.
> >
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
> > ---
> >  kernel/irq_work.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> > index 1588e3b..4829a31 100644
> > --- a/kernel/irq_work.c
> > +++ b/kernel/irq_work.c
> > @@ -79,17 +79,16 @@ static void __irq_work_queue(struct irq_work *work)
> >   *
> >   * Can be re-enqueued while the callback is still in progress.
> >   */
> > -bool irq_work_queue(struct irq_work *work)
> > +void irq_work_queue(struct irq_work *work)
> 
> Please also update the headers in include/linux/irq_work.h accordingly.
I have sent the patch again(some time back).Is it picked up?
http://www.gossamer-threads.com/lists/linux/kernel/1667796
> 
> Thanks.
> 
> >  {
> >         if (!irq_work_claim(work)) {
> >                 /*
> >                  * Already enqueued, can't do!
> >                  */
> > -               return false;
> > +               return;
> >         }
> >
> >         __irq_work_queue(work);
> > -       return true;
> >  }
> >  EXPORT_SYMBOL_GPL(irq_work_queue);
> >
> > --
> > 1.7.1
> >


