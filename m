Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaEVPxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:53:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaEVPxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:53:07 -0400
Message-ID: <537E1D4E.4040407@redhat.com>
Date: Thu, 22 May 2014 11:52:46 -0400
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
Subject: Re: [PATCH 1/3] fs/superblock: Unregister sb shrinker before ->kill_sb()
References: <1400749779-24879-1-git-send-email-mgorman@suse.de> <1400749779-24879-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1400749779-24879-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 05:09 AM, Mel Gorman wrote:
> From: Dave Chinner <david@fromorbit.com>
> 
> We will like to unregister the sb shrinker before ->kill_sb().
> This will allow cached objects to be counted without call to
> grab_super_passive() to update ref count on sb. We want
> to avoid locking during memory reclamation especially when
> we are skipping the memory reclaim when we are out of
> cached objects.

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
