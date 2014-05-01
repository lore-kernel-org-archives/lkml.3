Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaEAGjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:39:18 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:40214 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaEAGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404301744580.8415@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744580.8415@chino.kir.corp.google.com>
Date: Thu, 1 May 2014 15:39:12 +0900
Message-ID: <CAAmzW4Nj04rbdoe8dkA-r14j+5iStUxFLM5BEkTmgEB+tHtsUA@mail.gmail.com>
Subject: Re: [patch] mm, thp: do not perform sync compaction on pagefault
From: Joonsoo Kim <js1304@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-01 9:45 GMT+09:00 David Rientjes <rientjes@google.com>:
> Synchronous memory compaction can be very expensive: it can iterate an enormous
> amount of memory without aborting and it can wait on page locks and writeback to
> complete if a pageblock cannot be defragmented.
> Unfortunately, it's too expensive for pagefault for transparent hugepages and
> it's much better to simply fallback to pages.  On 128GB machines, we find that
> synchronous memory compaction can take O(seconds) for a single thp fault.

Hello,

AFAIK, synchronous compaction doesn't wait the page on writeback.
sync compaction pass MIGRATE_SYNC_LIGHT for migrate_mode,
instead of MIGRATE_SYNC. It results in skipping the page on writeback.

Thanks.
