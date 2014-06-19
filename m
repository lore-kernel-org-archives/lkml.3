Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103AbaFSUTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:19:44 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:49968
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756631AbaFSUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:19:42 -0400
Date: Thu, 19 Jun 2014 15:19:39 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <alpine.DEB.2.10.1406192127100.5170@nanos>
Message-ID: <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Thomas Gleixner wrote:

> Well, no. Look at the callchain:
>
> __call_rcu
>     debug_object_activate
>        rcuhead_fixup_activate
>           debug_object_init
>               kmem_cache_alloc
>
> So call rcu activates the object, but the object has no reference in
> the debug objects code so the fixup code is called which inits the
> object and allocates a reference ....

So we need to init the object in the page struct before the __call_rcu?

