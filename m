Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaFQQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:28:25 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:55355
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933404AbaFQQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:28:22 -0400
Date: Tue, 17 Jun 2014 11:28:19 -0500 (CDT)
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
In-Reply-To: <20140617160508.GF31819@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406171125340.20610@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
 <20140617160040.GE31819@htj.dyndns.org> <20140617160508.GF31819@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Tejun Heo wrote:

> On Tue, Jun 17, 2014 at 12:00:40PM -0400, Tejun Heo wrote:
> > Hello, Christoph.
> >
> > On Tue, Jun 17, 2014 at 10:56:10AM -0500, Christoph Lameter wrote:
> > > Uhhh no. The percpu stuff and the associated per cpu atomics are to be
> > > used for stuff that is per cpu specific and runs at the fastest speed
> > > doable at that level. Introducing implicit barriers is not that good an
> > > idea.
> >
> > Hmmm?  Read barriers are noops on all archs except for alpha and
>
> Oops, data dependency barriers, not read barrier.

Even alpha maintains the illusion of changes becoming visible in the
proper order for the currently executing thread. No barriers are needed.


