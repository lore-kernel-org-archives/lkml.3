Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaFTPYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:24:03 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:46209 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbaFTPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:24:02 -0400
Date: Fri, 20 Jun 2014 10:23:57 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140619211543.GD9814@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406201022300.10810@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <alpine.DEB.2.11.1406171401350.22064@gentwo.org> <20140617194017.GO4669@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191540240.4002@gentwo.org> <20140619204634.GB9814@mtj.dyndns.org> <alpine.DEB.2.11.1406191608290.5484@gentwo.org>
 <20140619211543.GD9814@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Tejun Heo wrote:

> Again, data dependency barrier is noop in all in-use archs.

A barrier limits what the compiler can do.

> > Remote write events are contrary to that design and are exceedingly rare.
> > An IPI is justifiable for such a rare event. At least in my use cases I
> > have always found that to be sufficient. Well, I designed the data
> > structures in a way that made this possible because of the design criteria
> > that did not allow me remote write access to other processors per cpu
> > data.
>
> You're repeatedly getting wayside in the discussion.  What are you
> suggesting?  Sending IPIs on each percpu allocation?

No this is about sending an IPI if you want to modify the percpu data of
another process. There was a mentionig of code that modifies the per cpu
data of another processor?

> Again, I'm leaning towards just clarifying the init write ownership to
> the allocating CPU as that seems the most straight forward way to deal
> with it, but please stop brining up the raw performance thing.  Nobody
> is doing anything to that.  It's not relevant in the discussion.

Ok sounds good.

