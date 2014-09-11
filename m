Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaIKKCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:02:46 -0400
Received: from eu1sys200aog131.obsmtp.com ([207.126.144.205]:40702 "EHLO
	eu1sys200aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158AbaIKKCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:02:44 -0400
Message-ID: <541172D4.50608@mellanox.com>
Date: Thu, 11 Sep 2014 13:00:52 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <joro@8bytes.org>,
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
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Subject: Re: [RFC PATCH 1/6] mmu_notifier: add event information to address
 invalidation v4
References: <1409339415-3626-1-git-send-email-j.glisse@gmail.com> <1409339415-3626-2-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1409339415-3626-2-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.3.227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/2014 22:10, j.glisse@gmail.com wrote:
> + * - MMU_MUNMAP: the range is being unmapped (outcome of a munmap syscall or
> + * process destruction). However, access is still allowed, up until the
> + * invalidate_range_free_pages callback. This also implies that secondary
> + * page table can be trimmed, because the address range is no longer valid.

I couldn't find the invalidate_range_free_pages callback. Is that a left over 
from a previous version of the patch?

Also, I think that you have to invalidate the secondary PTEs of the range being 
unmapped immediately, because put_page may be called immediately after the 
invalidate_range_start returns.

Haggai
