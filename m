Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaBFPgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:36:44 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:49006
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbaBFPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:36:43 -0500
Date: Thu, 6 Feb 2014 09:36:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        penberg@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] slub: Do not assert not having lock in removing freed
 partial
In-Reply-To: <52F32F46.8090205@parallels.com>
Message-ID: <alpine.DEB.2.10.1402060936140.31869@nuc>
References: <20140205222112.742169e0@gandalf.local.home> <52F32F46.8090205@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Vladimir Davydov wrote:

> > @@ -2906,12 +2916,10 @@ static void early_kmem_cache_node_alloc(
> >  	inc_slabs_node(kmem_cache_node, node, page->objects);
> >
> >  	/*
> > -	 * the lock is for lockdep's sake, not for any actual
> > -	 * race protection
> > +	 * No locks need to be taken here as it has just been
> > +	 * initialized and there is no concurrent access.
> >  	 */
> > -	spin_lock(&n->list_lock);
> > -	add_partial(n, page, DEACTIVATE_TO_HEAD);
> > -	spin_unlock(&n->list_lock);
> > +	__add_partial(n, page, DEACTIVATE_TO_HEAD);
> >  }

Ahh.. Much better.

Acked-by: Christoph Lameter <cl@linux.com>

