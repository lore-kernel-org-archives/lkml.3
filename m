Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbaE3NvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:51:00 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:55092
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755692AbaE3Nu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:50:59 -0400
Date: Fri, 30 May 2014 08:50:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
cc: Marcelo Tosatti <mtosatti@redhat.com>, Li Zefan <lizefan@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations (v5)
In-Reply-To: <alpine.DEB.2.02.1405291638300.9336@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1405300849190.8240@gentwo.org>
References: <20140523193706.GA22854@amt.cnet> <20140526185344.GA19976@amt.cnet> <53858A06.8080507@huawei.com> <20140528224324.GA1132@amt.cnet> <20140529184303.GA20571@amt.cnet> <alpine.DEB.2.02.1405291555120.9336@chino.kir.corp.google.com>
 <20140529232819.GA29803@amt.cnet> <alpine.DEB.2.02.1405291638300.9336@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, David Rientjes wrote:

> When I said that my point about mempolicies needs more thought, I wasn't
> expecting that there would be no discussion -- at least _something_ that
> would say why we don't care about the mempolicy case.

Lets get Andi involved here too.

> The motivation here is identical for both cpusets and mempolicies.  What
> is the significant difference between attaching a process to a cpuset
> without access to lowmem and a process doing set_mempolicy(MPOL_BIND)
> without access to lowmem?  Is it because the process should know what it's
> doing if it asks for a mempolicy that doesn't include lowmem?  If so, is
> the cpusets case different because the cpuset attacher isn't held to the
> same standard?
>
> I'd argue that an application may never know if it needs to allocate
> GFP_DMA32 or not since its a property of the hardware that its running on
> and my driver may need to access lowmem while yours may not.  I may even
> configure CONFIG_ZONE_DMA=n and CONFIG_ZONE_DMA32=n because I know the
> _hardware_ requirements of my platforms.

Right. This is a hardware issue and the hardware is pretty messed up. And
now one wants to use NUMA features?

> If there is no difference, then why are we allowing the exception for
> cpusets and not mempolicies?
>
> I really think you want to allow both cpusets and mempolicies.  I'd like
> to hear Christoph's thoughts on it as well, though.

I said something elsewhere in the thread.
