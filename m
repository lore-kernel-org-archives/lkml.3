Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbaE3VSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:18:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbaE3VSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:18:34 -0400
Date: Fri, 30 May 2014 23:18:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Li Zefan <lizefan@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v5)
Message-ID: <20140530211831.GN25366@two.firstfloor.org>
References: <20140523193706.GA22854@amt.cnet>
 <20140526185344.GA19976@amt.cnet>
 <53858A06.8080507@huawei.com>
 <20140528224324.GA1132@amt.cnet>
 <20140529184303.GA20571@amt.cnet>
 <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
 <20140529232819.GA29803@amt.cnet>
 <alpine.DEB.2.02.1405291638300.9336@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1405300849190.8240@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405300849190.8240@gentwo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:50:56AM -0500, Christoph Lameter wrote:
> On Thu, 29 May 2014, David Rientjes wrote:
> 
> > When I said that my point about mempolicies needs more thought, I wasn't
> > expecting that there would be no discussion -- at least _something_ that
> > would say why we don't care about the mempolicy case.
> 
> Lets get Andi involved here too.

I'm not fully sure about the use case for this. On the NUMA systems
I'm aware of usually only node 0 has <4GB, so mem policy
is pointless.

But anyways it seems ok to me to ignore mempolicies. Mempolicies
are primarily for user space, which doesn't use GFP_DMA32.

-ANdi
