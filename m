Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157Ab3DITy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:54:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936042Ab3DITyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:54:24 -0400
Date: Tue, 9 Apr 2013 12:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] mm: remove compressed copy from zram in-memory
Message-Id: <20130409125423.19592f11e44345df2bca6cfd@linux-foundation.org>
In-Reply-To: <20130409010231.GA3467@blaptop>
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
	<20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
	<20130409010231.GA3467@blaptop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 10:02:31 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > Also, what's up with the SWP_BLKDEV test?  zram doesn't support
> > SWP_FILE?  Why on earth not?
> > 
> > Putting swap_slot_free_notify() into block_device_operations seems
> > rather wrong.  It precludes zram-over-swapfiles for all time and means
> > that other subsystems cannot get notifications for swap slot freeing
> > for swapfile-backed swap.
> 
> Zram is just pseudo-block device so anyone can format it with any FSes
> and swapon a file. In such case, he can't get a benefit from
> swap_slot_free_notify. But I think it's not a severe problem because
> there is no reason to use a file-swap on zram. If anyone want to use it,
> I'd like to know the reason. If it's reasonable, we have to rethink a
> wheel and it's another story, IMHO.

My point is that making the swap_slot_free_notify() callback a
blockdev-specific thing was restrictive.  What happens if someone wants
to use it for swapfile-backed swap?  This has nothing to do with zram.
