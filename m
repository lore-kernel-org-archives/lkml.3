Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbaFQTmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:42:52 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59640 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933009AbaFQTmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:42:51 -0400
Date: Tue, 17 Jun 2014 14:42:48 -0500 (CDT)
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
In-Reply-To: <20140617185605.GL31819@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406171440050.22064@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <20140617165702.GF4669@linux.vnet.ibm.com>
 <20140617185605.GL31819@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I much prefer the model where the thing that -published- the pointer is
> > responsible for memory ordering.  After all, if a task allocates some
> > zeroed memory, uses it locally, then frees it, there is no ordering
> > to worry about in the first place.  The memory allocator doing the
> > initialization cannot tell how the memory is to be used, after all.
>
> Yeah, "publish" is a nice verb to put on it.  No objection.

Well that "publishing" of the structure that contains the per cpu offset
is actually what most of the current code does. So we do not need any
additional synchronization. Clarifying the responsibility for
synchronization being with the code which does the alloc_percpu would be
good.
