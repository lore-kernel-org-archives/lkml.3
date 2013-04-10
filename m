Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332Ab3DJAQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:16:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54986 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765229Ab3DJAQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:16:16 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-84-5164af4d1397
Date: Wed, 10 Apr 2013 09:16:13 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] mm: remove compressed copy from zram in-memory
Message-ID: <20130410001613.GE6836@blaptop>
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
 <20130409010231.GA3467@blaptop>
 <20130409125423.19592f11e44345df2bca6cfd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130409125423.19592f11e44345df2bca6cfd@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:54:23PM -0700, Andrew Morton wrote:
> On Tue, 9 Apr 2013 10:02:31 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > > Also, what's up with the SWP_BLKDEV test?  zram doesn't support
> > > SWP_FILE?  Why on earth not?
> > > 
> > > Putting swap_slot_free_notify() into block_device_operations seems
> > > rather wrong.  It precludes zram-over-swapfiles for all time and means
> > > that other subsystems cannot get notifications for swap slot freeing
> > > for swapfile-backed swap.
> > 
> > Zram is just pseudo-block device so anyone can format it with any FSes
> > and swapon a file. In such case, he can't get a benefit from
> > swap_slot_free_notify. But I think it's not a severe problem because
> > there is no reason to use a file-swap on zram. If anyone want to use it,
> > I'd like to know the reason. If it's reasonable, we have to rethink a
> > wheel and it's another story, IMHO.
> 
> My point is that making the swap_slot_free_notify() callback a
> blockdev-specific thing was restrictive.  What happens if someone wants
> to use it for swapfile-backed swap?  This has nothing to do with zram.

Agree that it's not specific to zram even if zram is only user at the memont.
IMHO, more general one is that we introduce SWP_INMEMORY with
QUEUE_FLAS_INMEMORY_OR_SOMETHING so we can register swap_slot_free_notify
if backed device has a such type.

Do you really want to do above work(or alternative one, hope someone
in this thread suggest better idea) prio to this patch?
If so, I am happy to do it.
But my concern that it will introduce to change core kernel for staging one
where everyone ignore and apparently someone will regist it so will be stucked,
again.

So, I need a excuse to tell him "Hey guy, akpm told me "let's resolve
the issue prio to solving duplicated copy problem of zram although
it is for staging one". :)

Could you give me a license to kill? 

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
