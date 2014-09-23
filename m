Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaIWLov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:44:51 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36247 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIWLos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:44:48 -0400
Date: Tue, 23 Sep 2014 15:44:38 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Greg Thelen <gthelen@google.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@sr71.net>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: memcontrol: support transparent huge pages under
 pressure
Message-ID: <20140923114438.GI18526@esperanza>
References: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org>
 <xr934mvykgiv.fsf@gthelen.mtv.corp.google.com>
 <20140923082927.GG18526@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140923082927.GG18526@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:29:27PM +0400, Vladimir Davydov wrote:
> On Mon, Sep 22, 2014 at 10:52:50PM -0700, Greg Thelen wrote:
> > In this condition, if res usage is at limit then there's no point in
> > swapping because memsw.usage is already maximal.  Prior to this patch
> > I think the kernel did the right thing, but not afterwards.
> > 
> > Before this patch:
> >   if res.usage == res.limit, try_charge() indirectly calls
> >   try_to_free_mem_cgroup_pages(noswap=true)
> 
> But this is wrong. If we fail to charge res, we should try to do swap
> out along with page cache reclaim. Swap out won't affect memsw.usage,
> but will diminish res.usage so that the allocation may succeed.

Oops, I missed your point, sorry. If we hit the res.limit and
memsw.limit=res.limit, we automatically hit memsw.limit too, so there's
no point swapping out.

Thanks,
Vladimir
