Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbaKMQLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:11:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbaKMQLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:11:18 -0500
Message-ID: <5464D747.4030506@redhat.com>
Date: Thu, 13 Nov 2014 11:07:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jerome Glisse <j.glisse@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH 3/5] lib: lockless generic and arch independent page table
 (gpt) v2.
References: <1415644096-3513-1-git-send-email-j.glisse@gmail.com>	<1415644096-3513-4-git-send-email-j.glisse@gmail.com> <CA+55aFwHd4QYopHvd=H6hxoQeqDV3HT6=436LGU-FRb5A0p7Vg@mail.gmail.com>
In-Reply-To: <CA+55aFwHd4QYopHvd=H6hxoQeqDV3HT6=436LGU-FRb5A0p7Vg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 03:22 PM, Linus Torvalds wrote:

> Rik, the fact that you acked this just makes all your other ack's be
> suspect. Did you do it just because it was from Red Hat, or do you do
> it because you like seeing Acked-by's with your name?

I acked it because I could not come up with a better idea
on how to solve this problem.

Keeping the device page tables in sync with the CPU page
tables (and sometimes different, when a page is migrated
from system DRAM to VRAM) will require either expanded
macros and generic walker functions like this, or trusting
the device driver writers to correctly copy over example
code and implement their own...

I have seen too much copied-and-slightly modified code
in drivers to develop a dislike for the second alternative.

