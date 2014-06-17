Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbaFQSzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:55:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37243 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbaFQSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:55:17 -0400
Date: Tue, 17 Jun 2014 11:55:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617185510.GM4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
 <20140617160040.GE31819@htj.dyndns.org>
 <20140617160508.GF31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171125340.20610@gentwo.org>
 <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com>
 <alpine.DEB.2.11.1406171345240.21931@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406171345240.21931@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061718-8236-0000-0000-0000032BE50D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 01:47:01PM -0500, Christoph Lameter wrote:
> 
> On Tue, 17 Jun 2014, Linus Torvalds wrote:
> 
> > On Jun 17, 2014 6:28 AM, "Christoph Lameter" <cl@gentwo.org> wrote:
> > >
> > > Even alpha maintains the illusion of changes becoming visible in the
> > > proper order for the currently executing thread. No barriers are needed.
> >
> > No Christoph, alpha really doesn't. Barriers needed.
> 
> Everythig breaks if a single hardware execution thread can no longer
> observe a consistent view of the world of the data it modifies.
> 
> We are not talking about synchronization here between multiple hardware
> threads. This is simply code running on a single hardware thread and all
> architectures maintain the uniprocessor illusion there.

We are talking about one CPU initializing all CPUs' portions of
dynamically allocated per-CPU memory, so there really is more than
one CPU involved.

							Thanx, Paul

