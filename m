Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3GWPdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:33:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50793 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798Ab3GWPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:33:12 -0400
Date: Tue, 23 Jul 2013 11:32:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sam Ben <sam.bennn@gmail.com>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC 2/4] Have __free_pages_memory() free in larger chunks.
Message-ID: <20130723153257.GK715@cmpxchg.org>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
 <1373594635-131067-3-git-send-email-holt@sgi.com>
 <51E5447D.70901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5447D.70901@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:02:53PM +0800, Sam Ben wrote:
> Hi Robin,
> On 07/12/2013 10:03 AM, Robin Holt wrote:
> >Currently, when free_all_bootmem() calls __free_pages_memory(), the
> >number of contiguous pages that __free_pages_memory() passes to the
> >buddy allocator is limited to BITS_PER_LONG.  In order to be able to
> 
> I fail to understand this. Why the original page number is BITS_PER_LONG?

The mm/bootmem.c implementation uses a bitmap to keep track of
free/reserved pages.  It walks that bitmap in BITS_PER_LONG steps
because it is the biggest chunk that is still trivial and cheap to
check if all pages are free in it (chunk == ~0UL).

nobootmem.c was written based on the bootmem.c interface, so it was
probably adapted to keep things similar between the two, short of a
pressing reason not to.
