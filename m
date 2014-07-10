Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaGJMJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:09:36 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53226 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaGJMJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:09:34 -0400
Date: Thu, 10 Jul 2014 08:09:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mm: vmscan: Only update per-cpu thresholds for
 online CPU
Message-ID: <20140710120931.GL29639@cmpxchg.org>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404893588-21371-5-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:13:06AM +0100, Mel Gorman wrote:
> When kswapd is awake reclaiming, the per-cpu stat thresholds are
> lowered to get more accurate counts to avoid breaching watermarks.  This
> threshold update iterates over all possible CPUs which is unnecessary.
> Only online CPUs need to be updated. If a new CPU is onlined,
> refresh_zone_stat_thresholds() will set the thresholds correctly.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
