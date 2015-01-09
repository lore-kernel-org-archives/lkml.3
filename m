Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbbAIVgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:36:19 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40277 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAIVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:36:17 -0500
Date: Fri, 9 Jan 2015 16:36:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Message-ID: <20150109213613.GC2785@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
 <20150108093057.GD14705@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108093057.GD14705@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Thu, Jan 08, 2015 at 10:30:57AM +0100, Jan Kara wrote:
> > * An inode may have pages dirtied by different memcgs, which naturally
> >   means that it should be able to be dirtied against multiple wb's.
> >   To support linking an inode against multiple wb's, iwbl
> >   (inode_wb_link) is introduced.  An inode has multiple iwbl's
> >   associated with it if it's dirty against multiple wb's.
>
>   Is the ability for inode to belong to multiple memcgs really worth the
> effort? It brings significant complications (see also Dave's email) and
> the last time we were discussing cgroup writeback support the demand from
> users for this was small... How hard would it be to just start with an
> implementation which attaches the inode to the first memcg that dirties it
> (and detaches it when inode gets clean)? And implement sharing of inodes
> among mecgs only if there's a real demand for it?

This was something I spent quite some time debating back and forth.
IMO, the complexity added from having to handle dirtying against
multiple cgroups isn't that high in the scheme of things.  It enables
use cases where different regions of an inode are actively shared by
multiple cgroups and more importantly makes unexpected behaviors a lot
less likely by aligning what writeback and blkcg sees with memcg's
perception.  As mentioned in the head message, this gives us the
ability to hook up dirty ratio handling correctly for each memcg.
That working properly strongly hinges on everybody involved seeing the
same picture.

Thanks.

-- 
tejun
