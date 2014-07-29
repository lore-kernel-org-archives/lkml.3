Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaG2JCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:02:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaG2JCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:02:36 -0400
Date: Tue, 29 Jul 2014 11:02:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: =?ISO-8859-15?Q?Petr_Ml=E1dek?= <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu buffer
 in parallel
In-Reply-To: <20140721123019.678788f1@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1407291057330.16390@pobox.suse.cz>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz> <20140716124356.398e21f4@gandalf.local.home> <20140718153443.GC6774@pathway.suse.cz> <20140721144324.GG20751@pathway.suse.cz> <20140721154317.GS8690@linux.vnet.ibm.com> <20140721161828.GH20751@pathway.suse.cz>
 <20140721123019.678788f1@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Steven Rostedt wrote:

> > I thought that IPI used NMI and thus could not be blocked if the
> > called function was reasonable. Note that ring_buffer_swap_cpu() does not take
> > any lock and can't block anywhere. I am probably too optimistic here.
> 
> Heh, that would be a crazy system. No, IPI is a normal maskable
> interrupt. It does not use NMIs. In fact, IPI is how irq_work is
> implemented to do stuff from an NMI outside of NMI context.

Just for the sake of completness -- on x86, it is possible to send NMI IPI 
by simply doing

	apic->send_IPI_mask(mask, NMI_VECTOR);

but obviously smp_call_funcion_*() are not using this.

-- 
Jiri Kosina
SUSE Labs
