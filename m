Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaKFVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaKFVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:04:12 -0500
Message-ID: <545BE218.8050506@redhat.com>
Date: Thu, 06 Nov 2014 16:03:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: j.glisse@gmail.com, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>, joro@8bytes.org,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>,
        Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
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
Subject: Re: [PATCH 2/5] mmu_notifier: keep track of active invalidation ranges
References: <1415047353-29160-1-git-send-email-j.glisse@gmail.com> <1415047353-29160-3-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1415047353-29160-3-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/03/2014 03:42 PM, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> The mmu_notifier_invalidate_range_start() and 
> mmu_notifier_invalidate_range_end() can be considered as forming
> an "atomic" section for the cpu page table update point of view. 
> Between this two function the cpu page table content is unreliable
>  for the address range being invalidated.
> 
> Current user such as kvm need to know when they can trust the 
> content of the cpu page table. This becomes even more important to 
> new users of the mmu_notifier api (such as HMM or ODP).
> 
> This patch use a structure define at all call site to 
> invalidate_range_start() that is added to a list for the duration 
> of the invalidation. It adds two new helpers to allow querying if
> a range is being invalidated or to wait for a range to become
> valid.
> 
> For proper synchronization, user must block new range invalidation 
> from inside there invalidate_range_start() callback, before
> calling the helper functions. Otherwise there is no garanty that a
> new range invalidation will not be added after the call to the
> helper function to query for existing range.
> 
> Signed-off-by: Jérôme Glisse <jglisse@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUW+IYAAoJEM553pKExN6DGQ0H/AsZn+UKNsKtys8kCnouMzvM
SiCZQE4xCTdYM/vvyhg6Iw1INz0aNescYRhI2k++S16vgaaleXEDXthJ2gKO8qB7
dgZ3eBDj9SzYVee6i779w77Eq9w1nhoPLyzTMpyYyB5PvfwKU8kq/j44rBNFVkdU
byKnQzWvzOkaAtifvsZYR/uTABB8D39O+++mARy39SqZRBDtb3aGL/4QidHI52qD
OEqtRFTftZ/yaeKvmrGw16e6NtAiE9IN/51pGuSH8vLjg9v884lnealMtfuLPbKR
e3LXaWZfl3cRJkBQjqe252wNHvqCX7T1dKBI0+V3rMqQuUHyuKLGg+Rq6NX1b7Q=
=sdxT
-----END PGP SIGNATURE-----
