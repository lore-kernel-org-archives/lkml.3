Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaE0OVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:21:42 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:37260
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbaE0OVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:21:39 -0400
Date: Tue, 27 May 2014 09:21:32 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations
In-Reply-To: <20140523193706.GA22854@amt.cnet>
Message-ID: <alpine.DEB.2.10.1405270917510.13999@gentwo.org>
References: <20140523193706.GA22854@amt.cnet>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Marcelo Tosatti wrote:

> Zone specific allocations, such as GFP_DMA32, should not be restricted
> to cpusets allowed node list: the zones which such allocations demand
> might be contained in particular nodes outside the cpuset node list.
>
> The alternative would be to not perform such allocations from
> applications which are cpuset restricted, which is unrealistic.
>
> Fixes KVM's alloc_page(gfp_mask=GFP_DMA32) with cpuset as explained.

Memory policies are only applied to a specific zone so this is not
unprecedented. However, if a user wants to limit allocation to a specific
node and there is no DMA memory there then may be that is a operator
error? After all the application will be using memory from a node that the
operator explicitly wanted not to be used.

There is also the hardwall flag. I think its ok to allocate outside of the
cpuset if that flag is not set. However, if it is set then any attempt to
alloc outside of the cpuset should fail.

