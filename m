Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaGACEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:04:13 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:46061 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGACEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <1403920822-14488-5-git-send-email-j.glisse@gmail.com>
References: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
	<1403920822-14488-5-git-send-email-j.glisse@gmail.com>
Date: Mon, 30 Jun 2014 19:04:11 -0700
X-Google-Sender-Auth: 9SVeCbbr9vOsvImNi18Y4x7FIEQ
Message-ID: <CA+55aFyrDNVcT3meKTaaXhh4q4z1=g7zO_==mFb5Lhh70haScg@mail.gmail.com>
Subject: Re: [PATCH 4/6] mmu_notifier: pass through vma to invalidate_range
 and invalidate_page
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <j.glisse@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Anvin <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Jatin Kumar <jakumar@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Duncan Poole <dpoole@nvidia.com>, Oded Gabbay <Oded.Gabbay@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 7:00 PM, Jérôme Glisse <j.glisse@gmail.com> wrote:
>
> This needs small refactoring in memory.c to call invalidate_range on
> vma boundary the overhead should be low enough.

.. and looking at it, doesn't that mean that the whole invalidate call
should be moved inside unmap_single_vma() then, instead of being
duplicated in all the callers?

I really get the feeling that somebody needs to go over this
patch-series with a fine comb to fix these kinds of ugly things.

                     Linus
