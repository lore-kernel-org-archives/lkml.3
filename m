Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3EMJTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:19:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab3EMJTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:19:09 -0400
Date: Mon, 13 May 2013 10:19:02 +0100
From: Mel Gorman <mgorman@suse.de>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, bcrl@kvack.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
Message-ID: <20130513091902.GP11497@suse.de>
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com>
 <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com>
 <20130205120137.GG21389@suse.de>
 <20130206004234.GD11197@blaptop>
 <20130206095617.GN21389@suse.de>
 <5190AE4F.4000103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5190AE4F.4000103@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:11:43PM +0800, Tang Chen wrote:
> Hi Mel,
> 
> On 02/06/2013 05:56 PM, Mel Gorman wrote:
> >
> >There is the possibility that callbacks could be introduced for
> >migrate_unpin() and migrate_pin() that takes a list of PFN pairs
> >(old,new). The unpin callback should release the old PFNs and barrier
> >against any operations until the migrate_pfn() callback is called with
> >the updated pfns to be repinned. Again it would fully depend on subsystems
> >implementing it properly.
> >
> >The callback interface would be more robust but puts a lot more work on
> >the driver side where your milage will vary.
> >
> 
> I'm very interested in the "callback" way you said.
> 
> For memory hot-remove case, the aio pages are pined in memory and making
> the pages cannot be offlined, furthermore, the pages cannot be removed.
> 
> IIUC, you mean implement migrate_unpin() and migrate_pin() callbacks in aio
> subsystem, and call them when hot-remove code tries to offline
> pages, right ?
> 
> If so, I'm wondering where should we put this callback pointers ?
> In struct page ?
> 

No, I would expect the callbacks to be part the address space operations
which can be found via page->mapping.

-- 
Mel Gorman
SUSE Labs
