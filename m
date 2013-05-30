Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab3E3Tux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:50:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:35043 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3E3Tuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:50:44 -0400
Date: Thu, 30 May 2013 21:50:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ivo Sieben <meltedpianoman@gmail.com>, RT <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RFC: Set irq thread to RT priority on creation
In-Reply-To: <1369925681.26799.6.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1305302147290.2905@ionos>
References: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>  <alpine.LFD.2.02.1305301602490.2905@ionos> <1369925681.26799.6.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Steven Rostedt wrote:

> On Thu, 2013-05-30 at 16:07 +0200, Thomas Gleixner wrote:
> 
> > > This patch solves an issue for me where a device driver is expected to handle an
> > > interrupt immediatly after irq handlers are installed and interrupts enabled.
> > 
> > You miss to explain what kind of issue that is.
> 
> I could envision the case where the interrupt is initialized but doesn't
> go off until much later. If it never ran, then it would still be in
> SCHED_OTHER(), and that first interrupt could have a large delay.

Nope. As Ivo explained it's about an interrupt coming in right away,
i.e. before __setup_irq() reaches:

        if (new->thread)
	   wake_up_process(new->thread);

The ones which come much later do not have that issue as the thread
code already sits in the waiting loop and already adjusted the
priority.

Thanks,

	tglx

