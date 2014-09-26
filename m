Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaIZKkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:40:11 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63147 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaIZKkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:40:09 -0400
Date: Fri, 26 Sep 2014 05:40:05 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Mel Gorman <mgorman@suse.de>,
        Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickens <hughd@google.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: page allocator bug in 3.16?
Message-ID: <20140926054005.5c7985c0@as>
In-Reply-To: <542512AD.9070304@vmware.com>
References: <54246506.50401@hurleysoftware.com>
	<20140925143555.1f276007@as>
	<5424AAD0.9010708@hurleysoftware.com>
	<542512AD.9070304@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 09:15:57 +0200
Thomas Hellstrom <thellstrom@vmware.com> wrote:

> On 09/26/2014 01:52 AM, Peter Hurley wrote:
> > On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
> >> There are six ttm patches queued for 3.16.4:
> >>
> >> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
> >> drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
> >> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
> >> drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
> >> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch
> >> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch
> > Thanks for info, Chuck.
> >
> > Unfortunately, none of these fix TTM dma allocation doing CMA dma allocation,
> > which is the root problem.
> >
> > Regards,
> > Peter Hurley
> 
> The problem is not really in TTM but in CMA, There was a guy offering to
> fix this in the CMA code but I guess he didn't probably because he
> didn't receive any feedback.
> 

Yeah, the "solution" to this problem seems to be "don't enable CMA on
x86". Maybe it should even be disabled in the config system.
