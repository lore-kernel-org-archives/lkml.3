Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEWCsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 22:48:31 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54303 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaEWCsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 22:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
	<CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
Date: Fri, 23 May 2014 10:48:29 +0800
Message-ID: <CAAQ0ZWQDVxAzZVm86ATXd1JGUVoLXj_Y5Ske7htxH_6a4GPKRg@mail.gmail.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock and
 need_sched() contention
From: Shawn Guo <shawn.guo@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 07:49, Kevin Hilman <khilman@linaro.org> wrote:
> On Fri, May 16, 2014 at 2:47 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>> Compaction uses compact_checklock_irqsave() function to periodically check for
>> lock contention and need_resched() to either abort async compaction, or to
>> free the lock, schedule and retake the lock. When aborting, cc->contended is
>> set to signal the contended state to the caller. Two problems have been
>> identified in this mechanism.
>
> This patch (or later version) has hit next-20140522 (in the form
> commit 645ceea9331bfd851bc21eea456dda27862a10f4) and according to my
> bisect, appears to be the culprit of several boot failures on ARM
> platforms.

On i.MX6 where CMA is enabled, the commit causes the drivers calling
dma_alloc_coherent() fail to probe.  Tracing it a little bit, it seems
dma_alloc_from_contiguous() always return page as NULL after this
commit.

Shawn
