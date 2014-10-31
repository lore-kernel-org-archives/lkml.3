Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbaJaP6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:58:03 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:47590 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaJaP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:58:01 -0400
Date: Fri, 31 Oct 2014 10:17:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH for v3.18] mm/slab: fix unalignment problem on Malta with
 EVA due to slab merge
In-Reply-To: <1414742912-14852-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1410311015490.14859@gentwo.org>
References: <1414742912-14852-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Joonsoo Kim wrote:

> alloc_unbound_pwq() allocates slab object from pool_workqueue. This
> kmem_cache requires 256 bytes alignment, but, current merging code
> doesn't honor that, and merge it with kmalloc-256. kmalloc-256 requires
> only cacheline size alignment so that above failure occurs. However,
> in x86, kmalloc-256 is luckily aligned in 256 bytes, so the problem
> didn't happen on it.

That luck will run out when you enable debugging. But then that also
usually means disablign merging.

> To fix this problem, this patch introduces alignment mismatch check
> in find_mergeable(). This will fix the problem.

Acked-by: Christoph Lameter <cl@linux.com>
