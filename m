Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaEVP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaEVP7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:59:46 -0400
Message-ID: <537E1EE6.8080102@redhat.com>
Date: Thu, 22 May 2014 11:59:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/3] fs/superblock: Avoid locking counting inodes and
 dentries before reclaiming them
References: <1400749779-24879-1-git-send-email-mgorman@suse.de> <1400749779-24879-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1400749779-24879-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 05:09 AM, Mel Gorman wrote:
> From: Tim Chen <tim.c.chen@linux.intel.com>
> 
> We remove the call to grab_super_passive in call to super_cache_count.
> This becomes a scalability bottleneck as multiple threads are trying to do
> memory reclamation, e.g. when we are doing large amount of file read and
> page cache is under pressure.  The cached objects quickly got reclaimed
> down to 0 and we are aborting the cache_scan() reclaim.  But counting
> creates a log jam acquiring the sb_lock.

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
