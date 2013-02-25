Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3BYFPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 00:15:45 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57237 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3BYFPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 00:15:44 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-ed-512af37b725c
Date: Mon, 25 Feb 2013 14:16:15 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Message-ID: <20130225051615.GC12158@lge.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.02.1302221034380.7600@gentwo.org>
 <alpine.DEB.2.02.1302221057430.7600@gentwo.org>
 <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
 <5127A607.3040603@parallels.com>
 <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
 <CAAmzW4OG6b+7t2S3PUY710CDHkbSb9BWxzxWULm5EzJP4BGEXA@mail.gmail.com>
 <0000013d09a01f03-376fad0e-700d-4a04-8da2-89e6b3a22408-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013d09a01f03-376fad0e-700d-4a04-8da2-89e6b3a22408-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Sun, Feb 24, 2013 at 12:35:22AM +0000, Christoph Lameter wrote:
> On Sat, 23 Feb 2013, JoonSoo Kim wrote:
> 
> > With flushing, deactivate_slab() occur and it has some overhead to
> > deactivate objects.
> > If my patch properly fix this situation, it is better to use mine
> > which has no overhead.
> 
> Well this occurs during boot and its not that performance critical.

Hmm...
Yes, this is not performance critical place, but why do we use
a sub-optimal solution?

And flushing is abstration for complicated logic, so I think that
my raw implemntation is better for understanding.

But, I have no objection to merge Glauber's one
if you think that is better.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
