Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaBFB0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:26:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35094 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaBFB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:26:37 -0500
Date: Wed, 5 Feb 2014 17:26:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] slub: Do not assert not having lock in removing freed
 partial
In-Reply-To: <20140205200632.021dc613@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1402051725270.20281@chino.kir.corp.google.com>
References: <20140205192404.550da7dc@gandalf.local.home> <alpine.DEB.2.02.1402051644520.5159@chino.kir.corp.google.com> <20140205200632.021dc613@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> > We'll want to do something similiar for the add_partial() called from
> > early_kmem_cache_node_alloc(), right?  It had the added n->list_lock for 
> > the same reason and is done during early init where nobody else can be 
> > referencing a kmem_cache_node.
> > 
> > It would probably be better to define these in terms of "partial slabs 
> > that cannot have anyone else accessing it" rather than "freed slabs".
> 
> Perhaps then we just use the __remove_partial() and __add_partial()
> that does not do the checks. That's common practice to use a "__" to
> denote that it's special and usually doesn't require locking.
> 

Sounds appropriate.  Andrew released a mmotm today so I'm assuming it will 
be in linux-next tomorrow with my {add,remove}_full() patch but it 
shouldn't matter if you're going to be playing with 
{add,remove}_partial().
