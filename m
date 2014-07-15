Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaGOOGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:06:10 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:46106
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbaGOOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:06:04 -0400
Date: Tue, 15 Jul 2014 09:06:00 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140715101150.GA8690@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1407150903570.10593@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <87lhs35p0v.fsf@rustcorp.com.au>
 <20140714113911.GM16041@linux.vnet.ibm.com> <alpine.DEB.2.11.1407141014390.25436@gentwo.org> <20140715101150.GA8690@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Paul E. McKenney wrote:

> If I understand your initialization procedure correctly, you need at least
> an smp_wmb() on the update side and at least an smp_read_barrier_depends()
> on the read side.

A barrier for data that is not in the cache of the read side? That has
not been accessed yet (well there could have been a free_percpu before but
if so then the cache line was evicted by the initialization code).


