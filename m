Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480AbaFQQFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:05:13 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63286 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaFQQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:05:11 -0400
Date: Tue, 17 Jun 2014 12:05:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617160508.GF31819@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
 <20140617160040.GE31819@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617160040.GE31819@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:00:40PM -0400, Tejun Heo wrote:
> Hello, Christoph.
> 
> On Tue, Jun 17, 2014 at 10:56:10AM -0500, Christoph Lameter wrote:
> > Uhhh no. The percpu stuff and the associated per cpu atomics are to be
> > used for stuff that is per cpu specific and runs at the fastest speed
> > doable at that level. Introducing implicit barriers is not that good an
> > idea.
> 
> Hmmm?  Read barriers are noops on all archs except for alpha and

Oops, data dependency barriers, not read barrier.

> percpu pointer assignments aren't exactly a high frequency operation
> and I'm pretty sure we'll end up with a raw variant anyway.

-- 
tejun
