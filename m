Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab3JVFTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:19:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:6639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab3JVFTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396506928"
Date: Tue, 22 Oct 2013 13:16:36 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: introduce f2fs_kmem_cache_alloc to hide the
 unfailed kmem cache allocation
Message-ID: <20131022051636.GJ21006@hli22-desktop>
References: <5264D6C7.9000202@cn.fujitsu.com>
 <5265F5E6.3000604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265F5E6.3000604@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 11:49:58AM +0800, Gao feng wrote:
> On 10/21/2013 03:24 PM, Gu Zheng wrote:
> > +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
> > +						gfp_t flags)
> > +{
> > +	void *entry = kmem_cache_alloc(cachep, flags);
> > +retry:
> 
> retry after kmem_cache_alloc?

Good catch.

Sorry for the carelessness in my previous review. 
Besides this, I also found another issue as below:
 
> On Mon, Oct 21, 2013 at 03:24:55PM +0800, Gu Zheng wrote: 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c 
> > index ef80f79..fe3cf8e 100644 
> > --- a/fs/f2fs/node.c 
> > +++ b/fs/f2fs/node.c 
> > @@ -1308,11 +1308,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build) 
> >     if (allocated) 
> >             return 0; 
> >  retry: 
-retry?

