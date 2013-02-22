Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3BVQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:34:25 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:62944 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757519Ab3BVQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:34:21 -0500
Date: Fri, 22 Feb 2013 16:34:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
In-Reply-To: <512798CC.2080501@parallels.com>
Message-ID: <0000013d02c15c85-1443abb7-e86b-429c-8452-3f2218a9b38f-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com> <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
 <5127928A.20000@parallels.com> <0000013d02ab8230-de441d64-395f-4c87-89e7-3f2cd2209680-000000@email.amazonses.com> <512798CC.2080501@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Glauber Costa wrote:

> On 02/22/2013 08:10 PM, Christoph Lameter wrote:
> > kmem_cache_node creation runs before PARTIAL and kmem_cache runs
> > after. So there would be 2 kmem_cache_node structures allocated. Ok so
> > that would use cpu slabs and therefore remove pages from the partial list.
> > Pushing that back using the flushing should fix this. But I thought there
> > was already code that went through the cpu slabs to address this?
>
> not in bootstrap(), which is quite primitive. (and should remain so)

Joonsoo Kim had a patch for this. I acked it a while back AFAICR


