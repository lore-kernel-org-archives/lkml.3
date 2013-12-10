Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3LJPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:23:18 -0500
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:34815 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141Ab3LJPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:23:15 -0500
Date: Tue, 10 Dec 2013 15:23:13 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 35/41] tile: Replace __get_cpu_var uses
In-Reply-To: <52A62D9D.5080105@tilera.com>
Message-ID: <00000142dd1ad7dd-f4ddd24d-522c-4ec7-b40d-ff2fc167b52c-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233303.460840679@linux.com> <52A62D9D.5080105@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Chris Metcalf wrote:

> Except for a comment typo:
>
> >  /*
> >   * Read the set of maskable interrupts.
> > - * We avoid the preemption warning here via __this_cpu_ptr since even
> > + * We avoid the preemption warning here via raw_cpu_ptr since even
> >   * if irqs are already enabled, it's harmless to read the wrong cpu's
> >   * enabled mask.
> >   */
> >  #define arch_local_irqs_enabled() \
> > -	(*__this_cpu_ptr(&interrupts_enabled_mask))
> > +	raw_cpu_read(interrupts_enabled_mask)
>
> Should be raw_cpu_read() in the comment.

Ok fixed.

> I assume you are planning to submit these through your own tree, not the arch trees?

Well once the core pieces are in then they can go through the arch trees.

