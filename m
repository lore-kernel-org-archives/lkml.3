Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaE2Swi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbaE2Swg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:52:36 -0400
Date: Thu, 29 May 2014 15:46:49 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v3)
Message-ID: <20140529184649.GA20609@amt.cnet>
References: <20140523193706.GA22854@amt.cnet>
 <20140526185344.GA19976@amt.cnet>
 <53858A06.8080507@huawei.com>
 <20140528224324.GA1132@amt.cnet>
 <alpine.DEB.2.10.1405281838370.6096@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405281838370.6096@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, May 28, 2014 at 06:45:04PM -0500, Christoph Lameter wrote:

<snip>

Much cleaner, sent v4 with your suggestions.

> Why call __alloc_pages_nodemask at all if you want to skip the node
> handling? Punt to alloc_pages()

- __alloc_pages_nodemask ignored GFP_DMA32 on older kernels, so the
interface should remain functional.
- There are others callers of alloc_pages(GFP_DMA) that can suffer
from the same problem.
- Mirrors mempolicy behaviour.


