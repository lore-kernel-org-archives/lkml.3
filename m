Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbaFQP4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:56:18 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:57869 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933099AbaFQP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:56:13 -0400
Date: Tue, 17 Jun 2014 10:56:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140617152752.GC31819@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Tejun Heo wrote:


> * Add data dependency barrier to percpu accessors and write barrier to
>   the allocator with the comment that this will be replaced with
>   proper assignment macros and mark this change w/ -stable.
>
> * Later, introduce percpu pointer assignment macros and convert all
>   users and remove the wmb added above.

Uhhh no. The percpu stuff and the associated per cpu atomics are to be
used for stuff that is per cpu specific and runs at the fastest speed
doable at that level. Introducing implicit barriers is not that good an
idea.

The concurrency guarantees for the per cpu operations are related to being
interrupted or rescheduled but not for accesses from other processors.

Cpus maintain at least the appearance of operations being visible in
sequence for code running on the same processor. Therefore no barriers are
needed.

