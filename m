Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3AOPgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:36:13 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:23681 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab3AOPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:36:12 -0500
Date: Tue, 15 Jan 2013 15:36:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] slub: correct bootstrap() for kmem_cache,
 kmem_cache_node
In-Reply-To: <1358234402-2615-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013c3eda78d8-da8c775c-d7c0-4a88-bacf-0b5160b5c668-000000@email.amazonses.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com> <1358234402-2615-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Joonsoo Kim wrote:

> These didn't make any error previously, because we normally don't free
> objects which comes from kmem_cache's first slab and kmem_cache_node's.

And these slabs are on the partial list because the objects are typically
relatively small compared to page size. Do you have a system with a very
large kmem_cache size?

> Problem will be solved if we consider a cpu slab in bootstrap().
> This patch implement it.

At boot time only one processor is up so you do not need the loop over all
processors.
