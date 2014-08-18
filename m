Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaHRSvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:51:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59468 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:51:39 -0400
Date: Mon, 18 Aug 2014 09:37:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140818163757.GA30742@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081818-1344-0000-0000-0000038C1EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:19:39PM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Thomas Gleixner wrote:
> 
> > Well, no. Look at the callchain:
> >
> > __call_rcu
> >     debug_object_activate
> >        rcuhead_fixup_activate
> >           debug_object_init
> >               kmem_cache_alloc
> >
> > So call rcu activates the object, but the object has no reference in
> > the debug objects code so the fixup code is called which inits the
> > object and allocates a reference ....
> 
> So we need to init the object in the page struct before the __call_rcu?

And the needed APIs are now in mainline:

	void init_rcu_head(struct rcu_head *head);
	void destroy_rcu_head(struct rcu_head *head);

Over to you, Christoph!  ;-)

							Thanx, Paul

