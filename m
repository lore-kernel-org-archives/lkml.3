Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaFTP3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:29:08 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:39977 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbaFTP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:29:07 -0400
Date: Fri, 20 Jun 2014 10:29:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140619205137.GK4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406201024070.10810@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <alpine.DEB.2.11.1406171401350.22064@gentwo.org> <20140617194017.GO4669@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191540240.4002@gentwo.org> <20140619205137.GK4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> Or just keep doing what I am doing.  What exactly is the problem with it?
> (Other than probably needing to clean up the cache alignment of some
> of the per-CPU structures?)

Writing to a cacheline of another processor can impact performance of that
other processor since the cacheline (which may contain other performance
critical data) is evicted from that processors cache.

The mechanisms for handling percpu data are not designed with the
consideration of writes into foreign percpu data areas in mind. Surprises
may result from such use.

In particular I see a danger in understanding what "atomic" percpu
operations are. These are not to be confused with regular atomic ops.
Percpu atomics are atomic for accesses that occur in a single specific
hardware thread. Percpu "atomics" are atomic vs. interrupts or preemption
occuring on that specific processor. No serialization is supported for
accesses may it be read or write from foreign processors.


