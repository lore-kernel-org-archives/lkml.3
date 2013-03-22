Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3CVKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:31:48 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:60373 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3CVKbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:31:47 -0400
Date: Fri, 22 Mar 2013 10:31:46 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wfcqueue: functions for local append and enqueue
Message-ID: <20130322103146.GA9078@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130321114313.GA17275@dcvr.yhbt.net>
 <20130322020150.GA17809@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322020150.GA17809@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> * Eric Wong (normalperson@yhbt.net) wrote:
> >  /*
> > + * __wfcq_append_local: append one local queue to another local queue
> > + *
> > + * No memory barriers are issued.  Mutual exclusion is the responsibility
> > + * of the caller.
> > + *
> > + * Returns false if the queue was empty prior to adding the node.
> > + * Returns true otherwise.
> > + */
> > +static inline bool __wfcq_append_local(struct wfcq_head *head,
> 
> Following the rest of the header, we could use:
> 
> ___wfcq_append() for this function,

OK.

However, I think ___ is a little confusing (but I'm easily confused :x).
I didn't even realize some functions in wfcqueue.h had ___ (vs __) until
just now(!)

But I will resend later tonight/tomorrow with ___ for consistency with
the existing API unless I've convinced you "_local" is easier :)

On a related note to underscores, I totally missed the existence of
____cacheline_aligned_in_smp in my first RFC even though I had seen
the __ version for .data around.

> and:
> 
> __wfcq_enqueue()
> 
> we should also update the "Synchronization table" at the beginning of
> the file accordingly.

Will update.
