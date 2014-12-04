Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaLDU2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:28:15 -0500
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:48739 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbaLDU2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:28:12 -0500
Date: Thu, 4 Dec 2014 14:28:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Leonard Crestez <lcrestez@ixiacom.com>
cc: Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
In-Reply-To: <5480BFAA.2020106@ixiacom.com>
Message-ID: <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
References: <547E3E57.3040908@ixiacom.com> <20141204175713.GE2995@htj.dyndns.org> <5480BFAA.2020106@ixiacom.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Leonard Crestez wrote:

> Yes, we are actually experiencing issues with this. We create lots of virtual
> net_devices and routes, which means lots of percpu counters/pointers. In particular
> we are getting worse performance than in older kernels because the net_device refcnt
> is now a percpu counter. We could turn that back into a single integer but this
> would negate an upstream optimization.

Well this is not a common use case and that is not what the per cpu
allocator was designed for. There is bound to be signifcant fragmentation
with the current design. The design was for rare allocations when
structures are initialized.

> Having a "properly scalable" percpu allocator would be quite nice indeed.

I guess we would be looking at a redesign of the allocator then.

