Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab3GAPuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:50:25 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:55282 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735Ab3GAPuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:50:24 -0400
Date: Mon, 1 Jul 2013 15:50:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        lllllinux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/slab: Fix drain freelist excessively
In-Reply-To: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9aed7e5f-f95ae9c1-fb29-41c0-a5ff-9f9aa398c223-000000@email.amazonses.com>
References: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Wanpeng Li wrote:

> The drain_freelist is called to drain slabs_free lists for cache reap,
> cache shrink, memory hotplug callback etc. The tofree parameter is the
> number of slab objects to free instead of the number of slabs to free.
> The parameter transfered from callers is n->free_objects or n->freelimit
> + 5 * (searchp->num - 1) / (5 * searchp->num), and both of them mean
> the number of slabs objects. I add printk to dump drain information:

See my reply to V1.
