Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3FDP3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:29:22 -0400
Received: from www.sr71.net ([198.145.64.142]:39869 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab3FDP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:29:19 -0400
Message-ID: <51AE07CE.9040304@sr71.net>
Date: Tue, 04 Jun 2013 08:29:18 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 5/6] mm: vmscan: batch shrink_page_list() locking
 operations
References: <20130603200202.7F5FDE07@viggo.jf.intel.com> <20130603200208.6F71D31F@viggo.jf.intel.com> <20130604050103.GC14719@blaptop> <20130604060224.GE14719@blaptop>
In-Reply-To: <20130604060224.GE14719@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 11:02 PM, Minchan Kim wrote:
>> > Why do we need new lru list instead of using @free_pages?
> I got your point that @free_pages could have freed page by
> put_page_testzero of shrink_page_list and they don't have
> valid mapping so __remove_mapping_batch's mapping_release_page
> would access NULL pointer.
> 
> I think it would be better to mention it in comment. :(
> Otherwise, I suggest we can declare another new LIST_HEAD to
> accumulate pages freed by put_page_testzero in shrink_page_list
> so __remove_mapping_batch don't have to declare temporal LRU list
> and can remove unnecessary list_move operation.

If I respin them again, I'll add a comment.

I guess we could splice the whole list over at once instead of moving
the pages individually.  But, what are we trying to optimize here?
Saving a list_head worth of space on the stack?

