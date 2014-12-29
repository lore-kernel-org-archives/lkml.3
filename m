Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaL2Irh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:47:37 -0500
Received: from mx2.parallels.com ([199.115.105.18]:51494 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2Irg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:47:36 -0500
Date: Mon, 29 Dec 2014 11:47:28 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/2] memcg: account swap instead of memory+swap
Message-ID: <20141229084728.GB9984@esperanza>
References: <dd99dc0de2ce6fd9aa18b25851819b71a58dca7d.1419782051.git.vdavydov@parallels.com>
 <20141228190020.GA9385@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141228190020.GA9385@phnom.home.cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 02:00:20PM -0500, Johannes Weiner wrote:
> On Sun, Dec 28, 2014 at 07:19:12PM +0300, Vladimir Davydov wrote:
> > The design of swap limits for memory cgroups looks broken. Instead of a
> > separate swap limit, there is the memory.memsw.limit_in_bytes knob,
> > which limits total memory+swap consumption. As a result, under global
> > memory pressure, a cgroup can eat up to memsw.limit of *swap*, so it's
> > just impossible to set the swap limit to be less than the memory limit
> > with such a design. In particular, this means that we have to leave swap
> > unlimited if we want to partition system memory dynamically using soft
> > limits.
> > 
> > This patch therefore attempts to move from memory+swap to pure swap
> > accounting so that we will be able to separate memory and swap resources
> > in the sane cgroup hierarchy, which is the business of the following
> > patch.
> > 
> > The old interface acts on memory and swap limits as follows:
> 
> The implementation seems fine to me, but there is no point in cramming
> this into the old interface.  Let's just leave it alone and implement
> proper swap accounting and limiting in the default/unified hierarchy.

Agree - the patch will be cleaner, and we won't need to bother about
compatibility issues then.

Thanks,
Vladimir
