Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaBDEVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:21:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:37032 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDEVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:21:03 -0500
Date: Mon, 3 Feb 2014 20:20:21 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Weijie Yang <weijie.yang@samsung.com>, hughd@google.com,
        Minchan Kim <minchan@kernel.org>, shli@kernel.org,
        Bob Liu <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        Seth Jennings <sjennings@variantweb.net>,
        Heesub Shin <heesub.shin@samsung.com>, mquzik@redhat.com,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 3/8] mm/swap: prevent concurrent swapon on the same
 S_ISBLK blockdev
In-Reply-To: <20140203153628.5e186b0e4e81400773faa7ac@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1402032014140.29889@eggly.anvils>
References: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com> <20140203153628.5e186b0e4e81400773faa7ac@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Andrew Morton wrote:
> On Mon, 27 Jan 2014 18:03:04 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
> 
> > When swapon the same S_ISBLK blockdev concurrent, the allocated two
> > swap_info could hold the same block_device, because claim_swapfile()
> > allow the same holder(here, it is sys_swapon function).
> > 
> > To prevent this situation, This patch adds swap_lock protect to ensure
> > we can find this situation and return -EBUSY for one swapon call.
> > 
> > As for S_ISREG swapfile, claim_swapfile() already prevent this scenario
> > by holding inode->i_mutex.
> > 
> > This patch is just for a rare scenario, aim to correct of code.
> > 
> 
> hm, OK.  Would it be saner to pass a unique `holder' to
> claim_swapfile()?  Say, `p'?
> 
> Truly, I am fed up with silly swapon/swapoff races.  How often does
> anyone call these things?  Let's slap a huge lock around the whole
> thing and be done with it?

That answer makes me sad: we can't be bothered to get it right,
even when Weijie goes to the trouble of presenting a series to do so.
But I sure don't deserve a vote until I've actually looked through it.

Hugh
