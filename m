Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3BVQKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:10:32 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:13555 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757291Ab3BVQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:10:28 -0500
Date: Fri, 22 Feb 2013 16:10:27 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
In-Reply-To: <5127928A.20000@parallels.com>
Message-ID: <0000013d02ab8230-de441d64-395f-4c87-89e7-3f2cd2209680-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com> <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
 <5127928A.20000@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Glauber Costa wrote:

> At this point, we are already slab_state == PARTIAL, while
> init_kmem_cache_nodes will only differentiate against slab_state == DOWN.

kmem_cache_node creation runs before PARTIAL and kmem_cache runs
after. So there would be 2 kmem_cache_node structures allocated. Ok so
that would use cpu slabs and therefore remove pages from the partial list.
Pushing that back using the flushing should fix this. But I thought there
was already code that went through the cpu slabs to address this?


