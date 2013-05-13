Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3EMPBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:01:49 -0400
Received: from kanga.kvack.org ([205.233.56.17]:53596 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab3EMPBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:01:47 -0400
X-Greylist: delayed 1429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 11:01:47 EDT
Date: Mon, 13 May 2013 11:01:47 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable()
Message-ID: <20130513150147.GQ31899@kvack.org>
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <20130513143757.GP31899@kvack.org> <x49obcfnd6c.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49obcfnd6c.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 10:54:03AM -0400, Jeff Moyer wrote:
> How do you propose to move the ring pages?

It's the same problem as doing a TLB shootdown: flush the old pages from 
userspace's mapping, copy any existing data to the new pages, then 
repopulate the page tables.  It will likely require the addition of 
address_space_operations for the mapping, but that's not too hard to do.

		-ben
-- 
"Thought is the essence of where you are now."
