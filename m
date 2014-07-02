Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145AbaGBAeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:34:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54062 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaGBAen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:34:43 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 2 Jul 2014 09:39:52 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 2/9] slab: move up code to get kmem_cache_node in
 free_block()
Message-ID: <20140702003952.GA9972@js1304-P5Q-DELUXE>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1404203258-8923-3-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.02.1407011520120.4004@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407011520120.4004@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 03:21:21PM -0700, David Rientjes wrote:
> On Tue, 1 Jul 2014, Joonsoo Kim wrote:
> 
> > node isn't changed, so we don't need to retreive this structure
> > everytime we move the object. Maybe compiler do this optimization,
> > but making it explicitly is better.
> > 
> 
> Qualifying the pointer as const would be even more explicit.

Hello,

So what you recommend is something likes below?

-       struct kmem_cache_node *n = get_node(cachep, node);
+       struct kmem_cache_node * const n = get_node(cachep, node);

I don't have seen this form of code protecting pointer itself in mm.
Instead, I have seen 'const struct kmem_cache_node *n' which protects
memory pointed by pointer. But this case isn't that case.

Am I missing something?

> 
> > Acked-by: Christoph Lameter <cl@linux.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Thank you!

