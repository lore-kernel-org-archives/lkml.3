Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3DLCwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3DLCwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:52:53 -0400
Message-ID: <516776CD.4070109@redhat.com>
Date: Thu, 11 Apr 2013 22:51:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] mm: vmscan: Have kswapd writeback pages based on
 dirty pages encountered, not priority
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <1365505625-9460-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1365505625-9460-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 07:07 AM, Mel Gorman wrote:
> Currently kswapd queues dirty pages for writeback if scanning at an elevated
> priority but the priority kswapd scans at is not related to the number
> of unqueued dirty encountered.  Since commit "mm: vmscan: Flatten kswapd
> priority loop", the priority is related to the size of the LRU and the
> zone watermark which is no indication as to whether kswapd should write
> pages or not.
>
> This patch tracks if an excessive number of unqueued dirty pages are being
> encountered at the end of the LRU.  If so, it indicates that dirty pages
> are being recycled before flusher threads can clean them and flags the
> zone so that kswapd will start writing pages until the zone is balanced.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

I like your approach of essentially not writing out from
kswapd if we manage to reclaim well at DEF_PRIORITY, and
doing writeout more and more aggressively if we have to
reduce priority.

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
