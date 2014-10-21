Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaJUGti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:49:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaJUGth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:49:37 -0400
Date: Tue, 21 Oct 2014 08:49:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] memcg: remove activate_kmem_mutex
Message-ID: <20141021064935.GA9415@dhcp22.suse.cz>
References: <1413817889-13915-1-git-send-email-vdavydov@parallels.com>
 <20141020185306.GB505@dhcp22.suse.cz>
 <20141021063119.GM16496@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021063119.GM16496@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-10-14 10:31:19, Vladimir Davydov wrote:
> On Mon, Oct 20, 2014 at 08:53:06PM +0200, Michal Hocko wrote:
> > On Mon 20-10-14 19:11:29, Vladimir Davydov wrote:
> > > The activate_kmem_mutex is used to serialize memcg.kmem.limit updates,
> > > but we already serialize them with memcg_limit_mutex so let's remove the
> > > former.
> > > 
> > > Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> > 
> > Is this the case since bd67314586a3 (memcg, slab: simplify
> > synchronization scheme)?
> 
> No, it's since Johannes' lockless page counters patch where we have the
> memcg_limit_mutex introduced to synchronize concurrent limit updates (mm
> commit dc1815408849 "mm: memcontrol: lockless page counters").

Ahh, ok. Thanks for the clarification.

-- 
Michal Hocko
SUSE Labs
