Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaIKON1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:13:27 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:37976 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaIKONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:13:24 -0400
Date: Thu, 11 Sep 2014 10:13:09 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Haggai Eran <haggaie@mellanox.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>, joro@8bytes.org,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [RFC PATCH 1/6] mmu_notifier: add event information to address
 invalidation v4
Message-ID: <20140911141308.GA1969@gmail.com>
References: <1409339415-3626-1-git-send-email-j.glisse@gmail.com>
 <1409339415-3626-2-git-send-email-j.glisse@gmail.com>
 <541172D4.50608@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541172D4.50608@mellanox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:00:52PM +0300, Haggai Eran wrote:
> On 29/08/2014 22:10, j.glisse@gmail.com wrote:
> > + * - MMU_MUNMAP: the range is being unmapped (outcome of a munmap syscall or
> > + * process destruction). However, access is still allowed, up until the
> > + * invalidate_range_free_pages callback. This also implies that secondary
> > + * page table can be trimmed, because the address range is no longer valid.
> 
> I couldn't find the invalidate_range_free_pages callback. Is that a left over 
> from a previous version of the patch?
> 
> Also, I think that you have to invalidate the secondary PTEs of the range being 
> unmapped immediately, because put_page may be called immediately after the 
> invalidate_range_start returns.

This is because patchset was originaly on top of a variation of another
patchset :

https://lkml.org/lkml/2014/9/9/601

In which invalidate_range_free_pages was a function call right after cpu
page table is updated but before page are free. Hence the comment was
right if on top of that patchset but on top of master you are right this
comment is wrong.

Cheers,
Jérôme

> 
> Haggai
