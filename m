Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927AbaFQT4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:56:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52634 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803AbaFQT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:56:40 -0400
Date: Tue, 17 Jun 2014 12:56:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617195634.GQ4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171053230.20610@gentwo.org>
 <20140617160040.GE31819@htj.dyndns.org>
 <20140617160508.GF31819@htj.dyndns.org>
 <alpine.DEB.2.11.1406171125340.20610@gentwo.org>
 <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com>
 <alpine.DEB.2.11.1406171345240.21931@gentwo.org>
 <20140617185510.GM4669@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406171437570.22064@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406171437570.22064@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061719-0928-0000-0000-000002B6B7DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:39:46PM -0500, Christoph Lameter wrote:
> On Tue, 17 Jun 2014, Paul E. McKenney wrote:
> 
> > We are talking about one CPU initializing all CPUs' portions of
> > dynamically allocated per-CPU memory, so there really is more than
> > one CPU involved.
> 
> Well that only occurs on initialization before the address of the
> struct that contains the offset is available to other processors.

Given runtime dynamic allocation of per-CPU memory, you still need
proper synchronization.  And yes, on non-Alpha CPUs, the dependency
ordering through any pointer suffices on the use side.  The thing
doing allocation and initialization will still need memory barriers,
of course.

> During operation the percpu area functions like a single processor. And
> its designed that way to avoid synchronization issues and take full
> advantage of *no* synchronization for full speed. We compromise on that
> for statistics but that is only read access.

During operation that does not involve cross-CPU accesses, agreed.

							Thanx, Paul

