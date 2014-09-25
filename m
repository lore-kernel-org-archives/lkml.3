Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaIYXwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:52:55 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37909 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751875AbaIYXwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:52:54 -0400
Message-ID: <5424AAD0.9010708@hurleysoftware.com>
Date: Thu, 25 Sep 2014 19:52:48 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickens <hughd@google.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: page allocator bug in 3.16?
References: <54246506.50401@hurleysoftware.com> <20140925143555.1f276007@as>
In-Reply-To: <20140925143555.1f276007@as>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 03:35 PM, Chuck Ebbert wrote:
> There are six ttm patches queued for 3.16.4:
> 
> drm-ttm-choose-a-pool-to-shrink-correctly-in-ttm_dma_pool_shrink_scan.patch
> drm-ttm-fix-handling-of-ttm_pl_flag_topdown-v2.patch
> drm-ttm-fix-possible-division-by-0-in-ttm_dma_pool_shrink_scan.patch
> drm-ttm-fix-possible-stack-overflow-by-recursive-shrinker-calls.patch
> drm-ttm-pass-gfp-flags-in-order-to-avoid-deadlock.patch
> drm-ttm-use-mutex_trylock-to-avoid-deadlock-inside-shrinker-functions.patch

Thanks for info, Chuck.

Unfortunately, none of these fix TTM dma allocation doing CMA dma allocation,
which is the root problem.

Regards,
Peter Hurley
