Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3AOPqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:46:19 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:40223 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab3AOPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:46:18 -0500
Date: Tue, 15 Jan 2013 15:46:17 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slub: correct to calculate num of acquired objects
 in get_partial_node()
In-Reply-To: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <0000013c3ee3b69a-80cfdc68-a753-44e0-ba68-511060864128-000000@email.amazonses.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Joonsoo Kim wrote:

> There is a subtle bug when calculating a number of acquired objects.
> After acquire_slab() is executed at first, page->inuse is same as
> page->objects, then, available is always 0. So, we always go next
> iteration.

page->inuse is always < page->objects because the partial list is not used
for slabs that are fully allocated. page->inuse == page->objects means
that no objects are available on the slab and therefore the slab would
have been removed from the partial list.

> After that, we don't need return value of put_cpu_partial().
> So remove it.

Hmmm... The code looks a bit easier to understand than what we have right now.

Could you try to explain it better?
