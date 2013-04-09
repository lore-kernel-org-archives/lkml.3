Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936654Ab3DIXkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:40:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64938 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab3DIXkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:40:04 -0400
X-AuditID: 9c930197-b7b50ae00000018c-4b-5164a6d2a6a1
Date: Wed, 10 Apr 2013 08:40:02 +0900
From: Minchan Kim <minchan@kernel.org>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] mm: remove compressed copy from zram in-memory
Message-ID: <20130409234002.GD6836@blaptop>
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
 <20130409010231.GA3467@blaptop>
 <5163A8F4.7060807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5163A8F4.7060807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:36:52PM +0800, Ric Mason wrote:
> Hi Minchan,
> On 04/09/2013 09:02 AM, Minchan Kim wrote:
> >Hi Andrew,
> >
> >On Mon, Apr 08, 2013 at 02:17:10PM -0700, Andrew Morton wrote:
> >>On Mon,  8 Apr 2013 15:01:02 +0900 Minchan Kim <minchan@kernel.org> wrote:
> >>
> >>>Swap subsystem does lazy swap slot free with expecting the page
> >>>would be swapped out again so we can avoid unnecessary write.
> >>Is that correct?  How can it save a write?
> >Correct.
> >
> >The add_to_swap makes the page dirty and we must pageout only if the page is
> >dirty. If a anon page is already charged into swapcache, we skip writeout
> >the page in shrink_page_list, then just remove the page from swapcache and
> >free it by __remove_mapping.
> >
> >I did received same question multiple time so it would be good idea to
> >write down it in vmscan.c somewhere.
> >
> >>>But the problem in in-memory swap(ex, zram) is that it consumes
> >>>memory space until vm_swap_full(ie, used half of all of swap device)
> >>>condition meet. It could be bad if we use multiple swap device,
> >>>small in-memory swap and big storage swap or in-memory swap alone.
> >>>
> >>>This patch makes swap subsystem free swap slot as soon as swap-read
> >>>is completed and make the swapcache page dirty so the page should
> >>>be written out the swap device to reclaim it.
> >>>It means we never lose it.
> >>>From my reading of the patch, that isn't how it works?  It changed
> >>end_swap_bio_read() to call zram_slot_free_notify(), which appears to
> >>free the underlying compressed page.  I have a feeling I'm hopelessly
> >>confused.
> >You understand right totally.
> >Selecting swap slot in my description was totally miss.
> >Need to rewrite the description.
> 
> free the swap slot and free compress page is the same, isn't it?

I think so.
I just wanted to make my description more clear with more general terms. :)

Thanks.

-- 
Kind regards,
Minchan Kim
